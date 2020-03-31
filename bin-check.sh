#!/bin/bash

cgrade_root=$(pwd)
source $cgrade_root/env_vars.sh

start_time=$(date +"%F_%H-%M")

# this script produces a lot of junk files
mkdir $cgrade_tmp_runtime/$start_time-tmp/
cd $cgrade_tmp_runtime/$start_time-tmp/

touch $cgrade_logs/broken-packages-$start_time.txt

test_bin(){
    for file in $(ls $1):
        do 
            if [ -d $1/$file ]
            then
                test_bin $1/$file
            fi
            $1/$file  &
            pid=$! 
            exit_code=$?
            # sleep 0.01
            kill $pid
            echo "$1/$file exitcode: $exit_code" >> $cgrade_logs/log-$start_time.txt
            if [ $exit_code -eq 1 ]
            then
                echo "$1/$file exitcode: $exit_code" >> $cgrade_logs/broken-packages-$start_time.txt
            fi
        done
}

test_bin /bin
test_bin /sbin
test_bin /usr/bin
test_bin /usr/sbin
test_bin /usr/local/bin
test_bin /usr/local/sbin


echo "$(cat $cgrade_logs/log-$start_time.txt | wc -l) packages tested:"

if [ -s $cgrade_logs/broken-packages-$start_time.txt ]
then
    echo "$(cat $cgrade_logs/broken-packages-$start_time.txt | wc -l) packages broken"
    echo "Please find the list of broken packages at $cgrade_logs/broken-packages-$start_time.txt"
else
    echo "All packages functional"
    rm $cgrade_logs/broken-packages-$start_time.txt
fi

# clearing junk files
cd $cgrade_root
rm -rf $cgrade_tmp_runtime/$start_time-tmp/