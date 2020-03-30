#!/bin/bash 

#setting testing root location
cgrade_root=$(pwd)
source $cgrade_root/env_vars.sh

start_time=$(date +"%F_%H-%M")

echo "[*] Getting installed packages"
dpkg -l | grep ^ii | sed 's_  _\t_g' | 
cut -f 2 > $cgrade_backup/pkg-list-$start_time.txt

echo "[*] Getting size occupied by installed packages"
while read line 
do
    apt-cache show $line |
    grep "Installed-Size" |
     cut -d ' ' -f 2 >> $cgrade_tmp_runtime/$start_time-sizes.txt
done < $cgrade_backup/pkg-list-$start_time.txt

echo "[*] Checking for disk space availability"
available_size=$(df --output=avail / | grep -o '[[:digit:]]*')
status=$(python3 $cgrade_root/space-check.py $cgrade_tmp_runtime/$start_time-sizes.txt $available_size)


if [ $status -eq 1 ]
then    
echo "Disk space insufficient, cant corss-grade"
exit
fi

echo "Sufficient disk space available, proceed with cross-grade"
rm $cgrade_tmp_runtime/$start_time-sizes.txt