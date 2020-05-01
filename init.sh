#!/bin/bash

sudo echo "working with sudo rights"

sudo mkdir /var/backups/cross-grade
sudo mkdir /var/log/corss-grade
sudo mkdir /var/tmp/cross-grade
sudo mkdir /tmp/cross-grade

cgrade_root=$(pwd)

cd $root 
for exe in *
do 
    chmod +x $exe
done

chmod +x ./databses/postgresql.sh 