[Russian version](http://wiki.userside.eu/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0_%D1%81_%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%D0%BC_Docker)

First, install the [Docker](https://docs.docker.com/) and [Compose](https://docs.docker.com/compose/):


DOWNLOAD
========

Use any of the following two ways:

Clone from GIT repository
--------------------------

```
cd ~
git clone https://github.com/userside/userside-docker.git
cd userside-docker
```
*For update, run:*
```
git pull
```

Or download ZIP archive
-----------------------

```
cd ~
wget https://github.com/userside/userside-docker/archive/master.zip
unzip master.zip && rm master.zip
cd userside-docker-master
```

CONFIGURE
=========

Open the `docker-compose.yml` and edit environment values in services and volume devices if needed.

INSTALL USERSIDE
================

Create folders for mount volumes. The default directories are: /opt/userside and /opt/backup
```
sudo mkdir -p /opt/userside /opt/backup
```

Install ERP USERSIDE under Docker:
```
sudo make install
```
This action will complete the installation and configuration of the application.

After that you can fully use the ERP USERSIDE.

BACKUP USERSIDE DATA
====================

Backup is performed automatically every day by the cron.

To start backup manually, use:
```
sudo make backup
```

Restore database dump:
```
sudo make DUMP="userside_yyyy-mm-dd_hh-mm-ss.dump" dbrestore
```
The file with the specified name must be in the backup directory.

MAINTANCE
=========

Open PSQL tool (PostgreSQL client tool):
```
sudo make psql
```

Update Docker images and USERSIDE version:
```
sudo make update
```

Run USERSIDE INSTALL TOOL:
```
sudo make us-install
```

Run cron manually:
```
sudo make run-cron
```

Stop USERSIDE Environment Docker stack:
```
sudo make stop
```

Start USERSIDE Environment Docker stack:
```
sudo make up
```

Stop and remove USERSIDE Environment containers with volumes:
```
sudo make down
```
**Note!** Make sure you back up the data before this action!

UNINSTALL
=========

For full uninstall USERSIDE Environment Docker stack:
```
sudo make uninstall
```
**Note!** Make sure you back up the data before this action!
