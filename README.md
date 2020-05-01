Automating cross-grades on Debian installations
<br><br>
**WARNING: The author tested these scripts several times on both VMs and his main machine before pushing it to Github.
But use these scripts at your own risk. The author(s) can't be held liable if these scripts caused any kind of damage**
<br><br>

## Table of contents:

- [Table of contents:](#table-of-contents)
- [Dependencies:](#dependencies)
- [Supported architectures](#supported-architectures)
- [Installation](#installation)
- [Databases](docs/databases/Index.md)
- [Feasibility check](#feasibility-check)
  - [Availability of packages](#availability-of-packages)
- [Finding broken packages](#finding-broken-packages)
- [Clean up](#clean-up)
- [Troubleshooting](#troubleshooting)

**NOTE: These scripts require root privileges to carry out tasks**

## Dependencies:
    * python3

## Supported architectures
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
### Availability of packages
* #### Official repositories: 
    If all packages installed are from the official repositories, then they should be available across all officially supported architectures. 
* #### Canonical Snappy: 
    Not all packages are available across all architectures, please check [Snapcraft](https://snapcraft.io/). Databases and applications that use databases might have to be dumped before cross-grading, as they might store data in architecture-specific formats.
* #### Third-party repositories: 
    Due to the lack of data, I wasn't able to write scripts to take their backup or check of availability in other architectures. 

**NOTE:** Kindly create issues with details containing information on the third-party repositories that you use and the Snappy packages that you use so that I can write scripts for them. This would be of great help to me folks!

## Finding broken packages
After cross-grading, it is possible that a few packages can be rendered broken. To find them, run:
<br>
`# ./bin-check.sh`
<br>
If there are any broken packages, the script will output the filename containing the list of such packages. To view the list, run:
<br>
`# cat [filename]`
<br>
## Clean up
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
`/var/logs/cross-grade`
+ **Backup:**
`/var/backups/cross-grade`
contains list installed packages before cross-grading and list of missing packages.
