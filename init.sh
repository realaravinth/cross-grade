#!/bin/bash

sudo echo "working with sudo rights"

sudo mkdir /var/backups/cross-grade
sudo mkdir /var/log/corss-grade
sudo mkdir /var/tmp/cross-grade
sudo mkdir /tmp/cross-grade

cgrade_root=$(pwd)

sudo chmod 777 clean.sh  env_vars.sh  feasibility.sh  init.sh	bin-check.sh