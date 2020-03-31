# cross-grade
Automating cross-grades on Debian installations 

**NOTE: commands beginning with `#` has to be run with sudo rights**

## Supported architectures:
Please find the list of supported architectures at [Debian supported rchitectures page](https://wiki.debian.org/SupportedArchitectures). 

## Installation
There's no installing, just a few directories and a few permissions will have to granted. This process is automated by init.sh
<br>
`# chmod 777 init.sh && ./init.sh` 
<br>

## Feasibility check
To check feasibility, run:
<br>
`# ./feasibility.sh [target architecture]`
<br>
example for arm architecture:
<br>
`# ./feasibility.sh arm`
## Clean up:
The scripts in the project run with high verbosity and create a lot of files during run time. 
These files are not automatically deleted because they might come in handy during troubleshooting. 
<br>
**NOTE: Don't delete these files during the cross-grade**
<br>
The files can be deleted if the process is successful. To do that, run:
<br>
`# ./clean.sh`
## Troubleshooting
All files created by the cross-grade scripts will contain timestamps in their filenames. 
<br>
+ **Logs:** 
`/var/logs/corss-grade`
+ **Backup info:**
`/var/backups/cross-grade`
contains list installed packages before cross-grading and list of missing packages.
