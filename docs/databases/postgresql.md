# PostgreSQL

PostgreSQL is a popular object-relational database management system (ORDBMS) that is officially supported by the Debian project.

## Introduction
`postgres.sh` must be run with root privileges. The script will intelligently find the highest privilege postgreSQL user and will perform database dumps of all databases available in UTF-8.

The database dumps can be found at `/var/backups/cross-grade`.

# Instructions
 `# ./postgres.sh`
