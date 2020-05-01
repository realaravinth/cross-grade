#!/bin/bash

#setting testing root location
cgrade_root="/home/aravinth/cross-grade"

source $cgrade_root/env_vars.sh

start_time=$(date +"%F_%H-%M")
echo head1
puser=$(head -n $(cat -n /etc/group | cut -d ":" -f 1 | grep "postgres" | tr -d "[:blank:]"\
	| cut -d "p" -f 1 ) /etc/group | tail -1 | cut -d ":" -f 4)

echo $start_time
echo $puser 
runuser -l $puser -c "psql -c '\du' ;" \
    > $cgrade_tmp_runtime/$start_time-users.txt
psuperuser=$(cat $cgrade_tmp_runtime/$start_time-users.txt \
    | grep "Superuser" | cut -d "|" -f 1 | tr -d "[:blank:]" )

echo $psuperuser

runuser -l $psuperuser -c "psql -c '\l'" | tail -n +4 | cut -d "|" -f 1 \
    |tr -d "[:blank:]" | grep --regexp="[A-Za-z]" \
    | head -n -1 >$cgrade_tmp_runtime/$start_time-databases.txt

while read database
do
  dir=$(runuser -l $psuperuser -c "pwd")
  runuser -l $psuperuser -c "pg_dumpall  --database=$database  \
      --superuser=postgres --encoding=utf-8 \
      >$dir/databases-$start_time-$database"
  mv $dir/databases-$start_time-$database $cgrade_backup/
done < $cgrade_tmp_runtime/$start_time-databases.txt 