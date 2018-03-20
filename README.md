First, install the [Docker](https://docs.docker.com/) and [Compose](https://docs.docker.com/compose/):


DOWNLOAD
========

Clone from GIT repository:
```
cd ~
git clone https://github.com/userside/userside-docker.git
cd userside-docker
```

Or download ZIP archive:
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

MAINTANCE
=========

Stop USERSIDE Environment Docker stack:
```
sudo make stop
```

Start USERSIDE Environment Docker stack:
```
sudo make up
```

Stop and remove USERSIDE Environment containers:
```
sudo make down
```

Open PSQL tool (PostgreSQL client tool):
```
sudo make psql
```

Run USERSIDE INSTALL TOOL:
```
sudo make us-install
```

Run cron manually:
```
sudo make us-cron
```

Run backup manually:
```
sudo make us-backup
```

UNINSTALL
=========

For full uninstall USERSIDE Environment Docker stack:
```
sudo make uninstall
```
