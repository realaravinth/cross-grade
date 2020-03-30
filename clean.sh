#!/bin/bash
cgrade_root=$(pwd)
source $cgrade_root/env_vars.sh

rm -rf /var/backups/cross-grade
rm -rf /var/logs/corss-grade
rm -rf /var/tmp/cross-grade
rm -rf /tmp/cross-grade