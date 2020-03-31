#!/bin/bash 

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
