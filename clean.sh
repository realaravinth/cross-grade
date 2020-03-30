#!/bin/bash
cgrade_root=$(pwd)
source $cgrade_root/env_vars.sh

rm -rf $cgrade_logs
rm -rf $cgrade_backup
rm -rf $cgrade_tmp_persist
rm -rf $cgrade_tmp_runtime