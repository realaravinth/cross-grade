#!/bin/bash 


# getting target architecture 
arch="amd64 arm64 armel armf i386 mipsel mips64el ppc64el s390x
alpha arm AVR32 hppa hurd-1386 ia64 kfreebsd-amd64kfreebsd-i386
m32 m68k mips netbsd-1376 netbsd-alphaor1k powerpc powerpcspe
riscv64 s390 sparc sparc64 sh4 x32"

print_help(){
    echo -e "\e[1m Usage: ./feasibility.sh  [target architecture] "
    echo
    echo -e "\e[1m Officially supported architechtures by Debian stable:"
    echo -e "\t\e[0m amd64 arm64 armel armf i386 mipsel mips64el ppc64el s390x"
    echo 
    echo -e "\e[1m Unofficially supported architechtures by Debian stable: "
    echo -e "\t\e[0m alpha arm AVR32 hppa hurd-1386 ia64 kfreebsd-amd64kfreebsd-i386"
    echo -e "\t m32 m68k mips netbsd-1376 netbsd-alphaor1k powerpc powerpcspe"
    echo -e "\t riscv64 s390 sparc sparc64 sh4 x32"
    exit
}

arg_check=1
if [ -z $1 ]
then
    print_help
elif [ -n $1 ]
then
    for i in $arch
    do
        if [ $1 = $i ]
        then
            arg_check=0
        fi    
    done
    if [ $arg_check -eq 1 ]  
    then    
        print_help
    fi
else
    print_help
fi

#setting testing root location
cgrade_root=$(pwd)
source $cgrade_root/env_vars.sh

start_time=$(date +"%F_%H-%M")

echo  ":: Getting installed packages"
dpkg -l | grep ^ii | sed 's_  _\t_g' | 
cut -f 2 > $cgrade_backup/pkg-list-$start_time.txt
printf "\xE2\x9C\x94  Receieved installed packages"


echo -e "\n:: Getting size occupied by installed packages"
num_packages=$(cat $cgrade_backup/pkg-list-$start_time.txt | wc -l)
count=0

while read line 
do
    apt-cache show $line |
    grep "Installed-Size" |
     cut -d ' ' -f 2 >> $cgrade_tmp_runtime/$start_time-sizes.txt

    count=$(expr $count + 1)

    # Using Teddy fearside's progress bar
    # (https://github.com/fearside/ProgressBar)
    let _progress=($count*100/${num_packages}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"


done < $cgrade_backup/pkg-list-$start_time.txt

printf "\n\xE2\x9C\x94  Size calculated"
echo -e "\n:: Checking for disk space availability"


available_size=$(df --output=avail / | grep -o '[[:digit:]]*')
status=$(python3 $cgrade_root/space-check.py $cgrade_tmp_runtime/$start_time-sizes.txt $available_size)

if [ $status -eq 1 ]
then  echo -e '\u274c Disk space insufficient, cant corss-grade'
exit
fi

echo -e '\xE2\x9C\x94  Sufficient disk space available, proceed with cross-grade'
rm $cgrade_tmp_runtime/$start_time-sizes.txt

echo -e ':: Checking for missing packages'
echo -e ':: Getting available packages list'
echo 

# I couldn't think for a more elegant way of handling the output of wget
wget https://packages.debian.org/stable/${1}/allpackages?format=txt.gz \
-O $cgrade_tmp_runtime/tmp-$start_time-avail-pks-list.txt.gz&> download_pid=$!
wait $download_pid
rm download_pid=

gunzip $cgrade_tmp_runtime/tmp-$start_time-avail-pks-list.txt.gz 
cat $cgrade_tmp_runtime/tmp-$start_time-avail-pks-list.txt |
     cut -d ' ' -f 1 > $cgrade_tmp_runtime/avail-pkg-list-$start_time.txt

rm -r $cgrade_tmp_runtime/tmp-$start_time-avail-pks-list.txt 

# preprocessing installed packages list

while read line                 
do
echo $line |
 cut -d ' ' -f 1 >> $cgrade_tmp_runtime/pkg-list-nospace-$start_time.txt
done < $cgrade_backup/pkg-list-$start_time.txt

while read line 
do
if [ $(echo $line | grep ":") ]
then echo $line | cut -d ":" -f 1 >> ../temp-pkg.txt
else
    echo $line >> $cgrade_tmp_runtime/pkg-list--nospacecolon-$start_time.txt
fi

done < $cgrade_tmp_runtime/pkg-list-nospace-$start_time.txt

rm $cgrade_tmp_runtime/pkg-list-nospace-$start_time.txt

#comparing packages
python3 $cgrade_root/compare.py \
    $cgrade_tmp_runtime/pkg-list--nospacecolon-$start_time.txt \
    $cgrade_tmp_runtime/avail-pkg-list-$start_time.txt \
    $cgrade_backup/missing-pkg-list-$start_time.txt

rm $cgrade_tmp_runtime/pkg-list--nospacecolon-$start_time.txt \
    $cgrade_tmp_runtime/avail-pkg-list-$start_time.txt 

if [ -s $cgrade_backup/missing-pkg-list-$start_time.txt ]
then
    echo "The following packages are missing in ${1}"
    cat $cgrade_backup/missing-pkg-list-$start_time.txt
    echo "Find missing packages list at ${cgrade_backup/missing-pkg-list-$start_time.txt}"
else
   echo -e '\xE2\x9C\x94  All packages are available in target architecture'
   rm $cgrade_backup/missing-pkg-list-$start_time.txt
fi