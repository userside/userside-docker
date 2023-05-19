[![EN](https://img.shields.io/badge/lang-en-green.svg)](#erp-userside-docker-bundle-v3181-en)
[![RU](https://img.shields.io/badge/lang-ru-yellow.svg)](#erp-userside-docker-bundle-v3181-ru)

# Table of contents
- [Table of contents](#table-of-contents)
- [ERP USERSIDE Docker Bundle v3.18.1 (EN)](#erp-userside-docker-bundle-v3181-en)
  - [About the project](#about-the-project)
  - [Installation](#installation)
  - [Updating](#updating)
    - [Within Docker bundle version 3.16 or 3.18](#within-docker-bundle-version-316-or-318)
    - [Upgrade from Docker bundle version 3.16 to version 3.18](#upgrade-from-docker-bundle-version-316-to-version-318)
      - [Configuration files](#configuration-files)
        - [file .env](#file-env)
        - [file bundle.bash](#file-bundlebash)
        - [file compose.yaml](#file-composeyaml)
      - [After editing the configuration files](#after-editing-the-configuration-files)
      - [Problems during upgrade between bundle versions](#problems-during-upgrade-between-bundle-versions)
    - [From Docker bundle version 3.12, 3.13 to version 3.16](#from-docker-bundle-version-312-313-to-version-316)
      - [Changes](#changes)
      - [Upgrading procedure](#upgrading-procedure)
  - [Exploitation](#exploitation)
    - [List of special commands](#list-of-special-commands)
      - [Basic commands](#basic-commands)
      - [Additional commands](#additional-commands)
    - [Backup](#backup)
      - [Database backup](#database-backup)
      - [Restore the database from a backup copy](#restore-the-database-from-a-backup-copy)
    - [Services that run in the background and the RabbitMQ broker](#services-that-run-in-the-background-and-the-rabbitmq-broker)
  - [Fine-tuning](#fine-tuning)
    - [PHP and FPM](#php-and-fpm)
    - [PostgreSQL](#postgresql)
  - [Using additional USERSIDE modules](#using-additional-userside-modules)
  - [Using multiple bundles on one server](#using-multiple-bundles-on-one-server)
    - [Installation](#installation-1)
      - [Deployment](#deployment)
      - [Configuring](#configuring)
        - [File .env](#file-env-1)
        - [File compose.yaml](#file-composeyaml-1)
    - [Reverse HTTP proxy](#reverse-http-proxy)
  - [Additions and corrections](#additions-and-corrections)
- [ERP USERSIDE Docker Bundle v3.18.1 (RU)](#erp-userside-docker-bundle-v3181-ru)
  - [О проекте](#о-проекте)
  - [Установка](#установка)
  - [Обновление](#обновление)
    - [В пределах версий Docker-бандла 3.16 или 3.18](#в-пределах-версий-docker-бандла-316-или-318)
    - [Обновление с версии Docker-бандла 3.16 на версию 3.18](#обновление-с-версии-docker-бандла-316-на-версию-318)
      - [Конфигурационные файлы](#конфигурационные-файлы)
        - [файл .env](#файл-env)
        - [файл bundle.bash](#файл-bundlebash)
        - [файл compose.yaml](#файл-composeyaml)
      - [После редактирования конфигурационных файлов](#после-редактирования-конфигурационных-файлов)
      - [Проблемы во время обновления между версиями бандла](#проблемы-во-время-обновления-между-версиями-бандла)
    - [С версии Docker-бандла 3.12, 3.13 до версии 3.16](#с-версии-docker-бандла-312-313-до-версии-316)
      - [Изменения](#изменения)
      - [Порядок обновления](#порядок-обновления)
  - [Эксплуатация](#эксплуатация)
    - [Список специальных команд](#список-специальных-команд)
      - [Основные команды](#основные-команды)
      - [Вспомогательные команды](#вспомогательные-команды)
    - [Резервное копирование](#резервное-копирование)
      - [Резервное копирование базы данных](#резервное-копирование-базы-данных)
      - [Восстановление базы данных из резервной копиии](#восстановление-базы-данных-из-резервной-копиии)
    - [Службы, работающе в фоне и брокер RabbitMQ](#службы-работающе-в-фоне-и-брокер-rabbitmq)
  - [Тонкая настройка](#тонкая-настройка)
    - [PHP и FPM](#php-и-fpm)
    - [PostgreSQL](#postgresql-1)
  - [Использование дополнительных модулей USERSIDE](#использование-дополнительных-модулей-userside)
  - [Использование нескольких бандлов на одном сервере](#использование-нескольких-бандлов-на-одном-сервере)
    - [Установка](#установка-1)
      - [Развёртывание](#развёртывание)
      - [Конфигурирование](#конфигурирование)
        - [Файл .env](#файл-env-1)
        - [Файл compose.yaml](#файл-composeyaml-1)
    - [Реверсивный HTTP-прокси](#реверсивный-http-прокси)
  - [Дополнения и исправления](#дополнения-и-исправления)


# ERP USERSIDE Docker Bundle v3.18.1 (EN)

**Warning!** Version 3.18 of this bundle has *Beta* status and may contain inaccuracies and bugs. Please do not update the production servers until this version has reached stable release status.

## About the project
This project is a **sample set** of configuration files and scripts to run the **Docker bundle** of the ERP USERSIDE system. All the images required for ERP USERSIDE are already built with all the necessary dependencies and settings and are located in [Docker HUB](https://hub.docker.com/repository/docker/erpuserside/userside). You can build your own bundle from these samples using Docker [Compose] (https://docs.docker.com/compose/) or using other orchestration tools of your choice. You can also use the samples as is and get a working ERP USERSIDE system without any further steps. We fully rely on your understanding of containerisation in Linux, Docker, Docker Compose, Swarm and the other systems you intend to use.

These samples of the Docker environment are distributed "as is" without warranty of any kind. We also do not provide technical support for the installation, configuration and maintenance of Docker and related tools. If you are not familiar with Docker, you should use the classic installation example of ERP USERSIDE on a Linux server. For example, on a virtual machine with Linux.

Within these instructions, the version of the Docker bundle that corresponds to the minimum USERSIDE version capable of running on that version of the bundle is used. For example, on Docker-bundle version 3.13 USERSIDE versions 3.13, 3.14, 3.15 may work, on Docker-bundle version 3.16 USERSIDE 3.16, 3.17 USERSIDE may work, and on Docker-bundle version 3.18 USERSIDE 3.18, 3.19 etc., until a new version of the bundle for some new USERSIDE version becomes available.

Do not confuse the Docker bundle version with the USERSIDE version.

Most of the complex commands in the form of functions and aliases are placed in the **bundle.bash** file, which must be plugged into a shell session before starting the bundle.

We recommend proxying HTTP requests to the bundle using an NGINX-based reverse proxy - this will allow you to use domain name based access as well as SSL and other features that are not available when using the bundle directly (such as IP address based access rights restriction). But you can use Userside in a Docker bundle without it. If you decide to use a reverse proxy, it would be more correct to configure it before installing Userside. Recommendations on how to configure it can be found at the bottom of the article in the section "Reverse HTTP proxy".

## Installation
1. Allocate the domain name for ERP USERSIDE and create the necessary entries on the DNS server or in the /etc/hosts file on the current server, check that the name resolves to the IP address correctly.
2. [Following the instructions, download and install](https://docs.docker.com/engine/install/) **Docker server** and plug-in **Compose**. If your operating system has Docker-IO installed from operating system packages, it must be removed in advance.
3. Create a directory to contain the bundle and navigate to it. For example:
```
sudo mkdir -p /docker && cd $_
```
4. Clone this repository into the userside subdirectory and navigate to it:
```
sudo git clone --depth 1 --branch=v3.18 https://github.com/userside/userside-docker.git userside && cd userside
```
5. Run the initialise bundle config command - this will create copies of the samples with working filenames. You now have the files **.env**, **compose.yaml**, **bundle.bash**.
```
sudo ./init.sh
```
6. Edit the **.env** file with `sudo nano .env` - specify all variable values in it ( bundle file deployment path, project name and locale, logins and passwords for services, etc.)
7. Optionally, only if needed, make changes to **compose.yaml** and, if really necessary, to **bundle.bash**. For example, in **compose.yaml** file, you can include alternative files **php.ini** and **www.conf** from **configs** directory by uncommenting the appropriate lines, and then copying files from applications (in config directory) and editing them as necessary. Alternatively, change the IP subnet address allocated to the bundle. If you have changed the default bundle subnet address, you will also need to change the host addresses for each ports list parameter in each service. The host address is the first subnet address. In addition, you also need to change the value of the `DOCKER_HOST_IP` variable in **bundle.bash**, specifying the same host IP address there.
8. Connect functions and aliases from **bundle.bash** to the current session:
```
source bundle.bash
```
9. Run the bundle and ERP USERSIDE installation with the following command and follow the instructions:
```
bundle-install
```
10. Create a WebSTOMP user to run websocket in one of the following ways. The password doesn't have to be too complex, but it doesn't have to be the same as any of your passwords, as they are *transmitted in plaintext* to the Frontend application:
     1. Alternatively, use RabbitMQ control panel. To do this open in a browser http://your.userside.net:15672 (change the domain to the one that is used for ERP USERSIDE, username and password as you specified in .env file for variables RABBITMQ_DEFAULT_USER and RABBITMQ_DEFAULT_PASS), go to tab **Admin**, at the bottom in section **Add a user** as a user name, for example, stompuser and set the password. Leave the tagged field blank. Then click **Add user**. Now above in section **All users**, click on the user you just created to open its settings. Under **Permissions** for **Configure regexp** and for **Read regexp**, specify `^userside-stomp:id-.*` and for **Write regexp**, delete the value leaving the field blank. Click the **Set permission** button.
     2. Or by running the command and following the instructions:
        ```
        rabbitmq-create-stomp-user
        ```
The WebSTOMP user name and password are specified in USERSIDE in the menu: Settings - Main - Websocket. If you are using a reverse proxy before the bundle, don't forget about `location` for `/ws` (more details below in the section on reverse proxy).

## Updating

### Within Docker bundle version 3.16 or 3.18
No further steps are required to update ERP USERSIDE within the 3.16 and 3.18 versions (e.g. from 3.16.4 to 3.16.7 or from 3.18.1 to 3.18.3). Run the command and follow the instructions:
```
bundle-update
```

### Upgrade from Docker bundle version 3.16 to version 3.18
Before upgrading something, back up the files as usual and then **must** back up the database to an SQL script - it will be required later:
```
source alias.bash

backup-make

mkdir -p ~/bundle_316
sudo sh -c "docker compose -p ${PROJECT_NAME} exec postgres pg_dump -U ${POSTGRES_USER} --no-acl -Fp -Z 5 ${POSTGRES_DB}" > ~/bundle_316/db_backup.sql.gz
```
A database backup will be created in your home directory. Make sure that the resulting database backup actually represents a SQL script and is not zero-sized. Only then proceed to the following steps.
```
ls -lh ~/bundle_316
```

Save the bundle files: .env, bundle.bash, docker-compose.yml (compose.yaml), Makefile in a secure place. Also save the cofigure files from the config subdirectory, if you changed them. Also, if any fine-tuning of PostgreSQL was done, copy data/db/postgresql.conf file. After deploying the new version of the bundle, you will need to configure the new bundle files by copying the values from these files.
```
sudo chmod -R +rX data/db
cp --parents {.env,bundle.bash,Makefile,docker-compose.yml,config/*,data/db/postgresql.conf} ~/bundle_316/
ls -lah ~/bundle_316
```

Save backups from the data/backup subdirectory in a secure location.

Stop the bundle:
```
bundle-stop
```

Before running the following command, check once again that you have copied all files, including backups!
This command will stop and remove all containers, including all mounted volumes:
```
${DOCKER_COMPOSE} down -v --remove-orphans
```

Until the userside 3.18 stable release, the current Docker bundle branch v3.18 also has a *Beta* status and has not yet been pushed into the master branch. For this reason, you should switch to the v3.18 branch before upgrading, and when the release comes out, you can switch back to the master branch:
```
sudo git fetch
sudo git checkout v3.18
sudo git pull
```

#### Configuration files
The new version 3.18 of the bundle has significant configuration differences. If you get confused while editing the configuration files, you can always start again by copying the example files and taking the values from the backed up configuration files you made earlier.

##### file .env
+ The `USERSIDE_BASE_DIR` environment variable is now called `ERP_BASE_DIR`. Change it's name. Also change the name of this variable in the compose.yaml file.
+ The `STOMP_USER` and `STOMP_PASSWORD` variables previously used for Makefile (abolished since 3.18) are no longer needed - they can be removed.
Also be sure to check the `.env` file against the example file `.env-example` to ensure that all variables are written correctly and there are no missing or superfluous variables.
```
sudo diff .env .env-example
```

##### file bundle.bash
This file has changed a lot, so we recommend copying it again from the example file `bundle.bash-example` and making the required changes if you have done so. Preferably, do not change anything in this file and use the whole file as shown in the example file.
```
sudo cp bundle.bash-example bundle.bash
```

##### file compose.yaml
If you have not modified the compose.yaml file (docker-compose.yml) in previous versions of the bundle, the best choice is to copy the compose.yaml file from the example:
```
sudo cp compose.yaml-example compose.yaml
```
If changes have been made, edit the compose.yaml file considering the following changes:
+ The `postgres` service now uses a Docker image based on **postgresql 15** (previously version 11 was used). Therefore, be sure to back up the database to a SQL script before upgrading to be able to restore to version 15. You can also remove the volume `backup:/backup` from the service - it is no longer needed as the backup job is now done on the host using the shortened commands from `bundle.bash`.
+ The `poller` service now has its own Docker service image **usm_poller** (previously a php shell was used instead of a full service image). Copy the entire `poller` service from the example file. Note that since Userside 3.18, most of the communication work is done by the external service usm_poller rather than the Userside kernel itself.
+ For all services that use images `erpuserside/userside:3.16-xxx` change the version to `erpuserside/userside:3.18-xxx`.
+ Change the variable name `USERSIDE_BASE_DIR` to `ERP_BASE_DIR`.
Also check the `compose.yaml` file against the example file `compose.yaml-example`.

If you had to change the subnet for the bundle (`subnet` in the `networks` settings section), you also need to make sure to change the IP address in each item of the `ports` list for each of the services - here you need to specify the host IP address, which is the first address from the subnet (not including the subnet address itself). For example, for the subnet 172.31.254.0/25, the IP address of the host will be 172.31.254.1. Also, in the bundle.bash file, change the value of the `DOCKER_HOST_IP` variable.


#### After editing the configuration files
As the `bundle.bash` file is significantly different from the one originally loaded, before proceeding, you should ensure that these changes are reflected in the shell session as well. To do this, you will have to log out of your shell session and then log in again. Once you have done this, upload the updated file:
```
source bundle.bash
```

Now the postgres service needs to be started. First make sure that the correct locale, database name, username and password are specified in `.env` and after that, run:
```
${DOCKER_COMPOSE} up postgres -d
```
When the new container is started, a new empty database will be created.

If you made any fine-tuning in the data/db/postgresql.conf file you backed up before the upgrade, restore those settings in the new file, but under no circumstances copy the old file from version 11 over the new file. They have significant differences.

In general we recommend that you use the postgresql parameter calculators to recalculate them for version 15, as they may vary considerably.

Now restore the backup to this database:
```
database-restore ~/bundle_316/db_backup.sql.gz
```
Make sure that no errors occur when restoring the database.

After restoring, check that the data is in the database, e.g. using an SQL query:
```
psql -At -c "SELECT (value::jsonb)->'vn' FROM key_value WHERE key='installer.release'"
```
The query should return information on the current version of Userside to which the database structure corresponds.

The update can be started. Run the update command and follow the instructions:
```
bundle-update
```

Once the update is complete, you will need to recreate the WebSocket user in RabbitMQ, as the global update of RabbitMQ has likely lost it. To find out the username and password that Userside is set to, go to Settings - Main - WebSocket in the Userside interface, or create a new username and password pair if required. Create a user for WebSocket in RabbitMQ by running the following command and responding to the prompt by entering the user name and password to be created.
```
rabbitmq-create-stomp-user
```

#### Problems during upgrade between bundle versions
If a problem occurs during an upgrade from 3.16 to 3.18, the installer will offer to correct the error and do a repair, however this will attempt to restore the previously installed version, which will be impossible due to incompatibilities between the PHP version in the 3.18 bundle and the userside of previous versions. Especially for such cases, you can use the command:
```
bundle-update force
```
For future upgrades from 3.18.x to 3.18.y, use the `erp-repair` command in case of problems.


### From Docker bundle version 3.12, 3.13 to version 3.16
When upgrading ERP USERSIDE to version 3.16, the Docker bundle must also be upgraded to version 3.16. The updated bundle includes a new set of containers required for background processes and a broker to manage the messages between them, which appeared in ERP USERSIDE 3.16.

#### Changes
+ All variable values (logins, passwords, etc.) are now placed in the `.env` file.
+ Redis now requires a mandatory password
+ Added services required for USERSIDE 3.16 (RabbitMQ, kernel worker, poller worker)

#### Upgrading procedure
1. Back up and stop the bundle:
```
backup-make && bundle-stop
```
If **Makefile** is used, then:
```
sudo make backup && sudo make stop
```
2. If you are using the **v3.13** branch instead of **master**, switch to the **v3.16** branch (or the **master** branch to always get the latest stable version of the bundle):
```
sudo git checkout v3.16
sudo git pull
```
3. Rename your current docker-compose.yml file so that its contents are not overwritten by the upgrade process:
```
sudo mv docker-compose.yml docker-compose_3-13.yml
```
4. Delete the Makefile file if you have not made any changes to it. Otherwise rename it too.
```
sudo rm Makefile
```
5. Run the initialisation command - it creates working files by copying the example template files:
```
sudo ./init.sh
```
6. From **docker-compose_3-13.yml** file, transfer all variable values to **.env**. Specify in the value of `USERSIDE_BASE_DIR` **full path** to the directory where the bundle is deployed (the current directory). In this example it is `/docker/userside`.
7. Since version 3.16 of the bundle, a password for Redis is **mandatory**. If you didn't have a password before, set it in the `REDIS_PASSWORD` variable in **.env** and then add to **./data/userside/.env** a variable `US_REDIS_PASSWORD` with exactly the same password.
8. The `.env` file has variables which are responsible for the number of containers run for handler services: `CORE_WORKER_NUM` and `POLLER_NUM`. By default, these are set to 10 and 5 respectively. If you need more handlers, change these numbers here. To start with **we recommend leaving them as default**.
9. Run the installation. When upgrading from version 3.13 to 3.16 of the bundle you will need to run this command, not **update**. In future upgrades within the 3.16 bundle you will need to use the update command.
```
bundle-install
```
If **Makefile** is used, then:
```
sudo make install
```
10. Ensure that the upgrade to ERP USERSIDE 3.16 goes correctly.
11. Delete the file **docker-compose_3-13.yml** - it is no longer required. If you have been saving a Makefile (step 4), transfer all your changes from it to the new Makefile and delete the old one.
```
sudo rm docker-compose_3-13.yml
```

## Exploitation
Most of the commands used are enclosed in the `bundle.bash` file as aliases or functions. To use this set of commands, connect this file to the current shell session by executing `source bundle.bash` or its shortened version `. bundle.bash`. You can now enter aliases and functions from this file at the command line, the meaning of which will be described below.

### List of special commands
#### Basic commands
+ `bundle-start` — run a Docker bundle
+ `bundle-stop` — stop all bundle containers
+ `bundle-restart` — restart the bundle
+ `bundle-install` — running environment initialisation for the bundle, then running the installer to install and then initialising tasks in the cron scheduler and other post-installation processes
+ `erp-install` — running the **installer** with the command *install*
+ `erp-repair` — running the **installer** with the command *repair*
+ `bundle-update` — performing all necessary procedures to complete the upgrading of the bundle and USERSIDE, including an initial backup
+ `bundle-destroy` — removal of Docker bundle and cron scheduler tasks. USERSIDE files are not deleted
+ `bundle-purge` — same as **bundle-destroy**, but also *removes* all USERSIDE files
+ `bundle-logs` — display the log of the Docker containers. As a parameter you can specify the name of the specific service
+ `erp-flush-cache` — cleaning the userside kernel caches
+ `backup-make` — performing file and database backups

#### Additional commands
+ `psql` — running the console utility **psql** to interact with the database
+ `rabbitmqctl` — running the console utility **rabbitmqctl** to control RabbitMQ

### Backup
The auto-deployment script installs and configures all necessary system components, including periodic backups (the job is set to the system cron). The archives are located in the **data/backup** subdirectory of the bundle.

If you need to perform an unplanned backup, run the command:
```
backup-make
```
A backup of the files and database will be created and placed in **./data/backup**.

#### Database backup
Starting from version 3.18 of the Docker bundle, database backups are done in a SQL script instead of Dump.

To perform a database backup, you can run a command that outputs the backup to the standard output:
```
database-backup > database.sql.gz
```
Or simply:
```
database-backup-to-file
```
In the later case, a file will be created in the data/backup subdirectory with a standard name, as with automatic backups.

#### Restore the database from a backup copy
To restore the database from a backup SQL script, use the command:
```
database-restore data/backup/userside_db_2023-04-07_16-25.sql.gz
```

### Services that run in the background and the RabbitMQ broker
To monitor the status of RabbitMQ broker is used module **RabbitMQ management** WEB-interface of which is available at http://your.userside.net:15672 (replace the domain with the one used for ERP USERSIDE, username and password as you set in **.env** file for variables `RABBITMQ_DEFAULT_USER` and `RABBITMQ_DEFAULT_PASS`).

If the background tasks are constantly running with a long delay, you should pay attention to the load of the queues (on the Queues tab) and if the queues are constantly or quite often and lasting a relatively large number of messages, you can change the number of instances of the background process running for each of them:

The **erp.core** queue is responsible for messages passed to the kernel handler. The number of instances of this handler can be set in the environment variable `CORE_WORKER_NUM` in the **.env** bundle file (not useride).

The **usm_poller** queue is responsible for messages sent to the poller module which performs hardware communication operations. The number of poller instances can be set in the environment variable `POLLER_NUM` in the **.env** bundle file (not useride).

If the values for these variables have changed, the bundle must be reloaded:
```
bundle-restart
```

## Fine-tuning
We recommend fine-tuning the environment for maximum performance. The principles are described [on our dedicated wiki page](https://wiki.userside.eu/Tuning).

### PHP and FPM
The settings for the Docker bundle services can be changed by using volumes. The **compose.yaml** file for **php**, **fpm** services has commented out volumes for files where additional fine-tuning options can be located.

Copy the php.ini-example and www.conf-example files in the config subdirectory to the php.ini and www.conf files respectively and edit them. Then uncomment the relevant volumes in the php and fpm services compose.yaml file and restart the bundle:
```
bundle-restart
```

### PostgreSQL
The PostgreSQL configuration files are in the data/db subdirectory and can be edited right there. After editing, the bundle must also be restarted:
```
bundle-restart
```

## Using additional USERSIDE modules
The compose.yaml file contains the **usm_billing** service which is an implementation of the billing module. This service is added as an example and can be removed from the configuration if it is not required. If you use this module, however, you need to fill in the basic parameters in the `environment` block of this service: `USERSIDE_API_KEY`, `BILLING_NAME`, `BILLING_URL`, `BILLING_ID`. The rest of the parameters are as required. Parameter `USERSIDE_API_URL` in case of using inside the bundle is not necessary: the server name will be filled in automatically.

[In our repository](https://github.com/orgs/userside/repositories) you can find examples of how to use other modules in Docker. The examples contain a fragment of the configuration of the bundle which can be used in the compose.yaml file of your bundle and step-by-step instructions on how to install and configure the module within the bundle.

If there is no such example of use for the module you are interested in, you can create one yourself using examples from other modules.

## Using multiple bundles on one server
If you need to use multiple copies of USERSIDE on one server, you should arrange multiple bundles - one for each copy. If the main directory where all the bundles are to be located is `/docker` (as per these instructions), and you need to use two separate copies of USERSIDE, for example, do the following

### Installation
#### Deployment
Create a directory `/docker`, if not already created, and navigate to it:
```
sudo mkdir -p /docker && cd $_
```

Clone the repository twice. Provide a clear name for each bundle so that you know exactly where it is in the future:
```
sudo git clone --depth 1 https://github.com/userside/userside-docker.git userside-production
sudo git clone --depth 1 https://github.com/userside/userside-docker.git userside-testing
```
As a result, you will get two catalogues: /docker/userside-production and /docker/userside-testing, each of which will host a different version of the bundle.

#### Configuring
Navigate to each of the directories and initialise:
```
cd /docker/userside-production && sudo ./init.sh
cd /docker/userside-testing && sudo ./init.sh
```

##### File .env
Now edit the `.env` file in each of the folders of the bundle. You must be sure to specify the absolute path to the bundle (the `ERP_BASE_DIR` variable) and the project name (the `PROJECT_NAME` variable), for example, **userside-production** and **userside-testing**.

If necessary, change the other variables. For example, it is not necessary to run 10 copies of core_worker processes for the USERSIDE test copy and it is not necessary to run 5 copies of poller microservices either. One copy at a time is sufficient for the test copy, because the load on the test copy is supposed to be minimal.

##### File compose.yaml
You must now make a change to the `compose.yaml` bundle configuration file. Here, only the settings relating to the network need to be changed. The bundles should use different subnets and the subnet size should be large enough to fit all the containers in the bundle with some margin.

By default, the subnet 172.31.254.0/25 is used in the example file. If this subnet suits you (does not overlap with existing subnets in the enterprise), leave it as it is in one of the bundles, and change it to e.g. 172.31.254.128/25 in the second. To do this, change the value for **subnet** in the **networks** settings box.

The first node address from each subnet will be given to the host interface and the rest will be randomly assigned to the bundle containers. In this example, IP addresses 172.31.254.1 and 172.31.254.129 will be assigned to bridgeXXX interfaces on the host. These addresses are convenient to use for container port translation.

Check the **ports** parameter of all services in compose.yaml carefully. It contains a list of ports that need to be translated for each of the services. For example, the entry `"172.31.254.1:8080:80"` for the **nginx** service means that port 8080 of the 172.31.254.1 interface on the host should be translated to port 80 inside the container with nginx. This allows network access inside the bundle to the container by addressing the IP address of the host.

Change the addresses so that these will be the addresses of the first nodes in the relevant subnet. For the described example this is 127.31.254.1 for the first bundle and 172.31.254.129 for the second bundle.

Also in the bundle.bash files, change the value of the `DOCKER_HOST_IP` variable to match the specific host IP address.

Remove the comment from the line broadcasting the WebSTOMP port number 15674 of the rabbitmq service. This should be done when using a reverse proxy before the bundle.

### Reverse HTTP proxy
We recommend using a reverse proxy even if you have one copy of Usersdide on your server. This allows more flexibility in configuring web access. For example, you can use SSL or configure the necessary access rights. But if a reverse proxy is not always necessary for one bundle, it is almost certainly necessary for two or more bundles.

![Two bundles with one reverse proxy](/img/nginx.png)

Install NGINX and configure it as a reverse proxy using the following method. The example uses domain names **userside.company.net** for the userside working copy and **test-us.company.net** for the userside test copy. If you have one copy, use one `server` block. Example:
```
server {
    listen 80;
    server_name userside.company.net;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://172.31.254.1:8080;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
    }

    location /ws {
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_pass http://172.31.254.1:15674/ws;
        proxy_http_version 1.1;
    }
}

server {
    listen 80;
    server_name test-us.company.net;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://172.31.254.129:8080;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
    }

    location /ws {
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_pass http://172.31.254.129:15674/ws;
        proxy_http_version 1.1;
    }
}
```

## Additions and corrections
Feedback, suggestions and bug reports about this Docker environment for USERSIDE are appreciated. You can report them through the Issue system of this repository. Suggestions and corrections in the form of Poll Request are also welcome.

---

# ERP USERSIDE Docker Bundle v3.18.1 (RU)

**Внимание!** Версия бандла 3.18 имеет статус *Beta* и может содержать неточности и ошибки. Пожалуйста, не обновляйте производственные серверы, пока эта версия не получит статуст стабильного релиза.

## О проекте
Данный проект представляет собой **набор образцов** конфигурационных файлов и скриптов для запуска **Docker-бандла** системы ERP USERSIDE. Все необходимые для работы ERP USERSIDE образы уже собраны со всеми необходимыми зависимостями и настройками и размещены в [Docker HUB](https://hub.docker.com/repository/docker/erpuserside/userside). Вы можете на основе данных образцов собрать свой бандл, используя Docker [Compose](https://docs.docker.com/compose/) либо испльзуя другие, удобные вам, инструменты оркестрации. Вы также можете воспользоваться образцами как есть и получить работающую систему ERP USERSIDE без каких либо дополнительных действий. Мы полностью полагаемся на ваше понимание работы контейнеризации в Linux, работы Docker, Docker Compose, Swarm и других систем, которые вы собираетесь использовать.

Данные образцы Docker-окружения распространяются «как есть» без каких либо гарантий. Мы также не оказываем техническую поддержку по вопросам установки, настройки и обслуживания Docker и связанных с ним инструментов. Если вы не знакомы с Docker, то вам следует воспользоваться классическим примером установки ERP USERSIDE на Linux-сервер. Например, на виртуальную машину с Linux.

В пределах этой инструкции используется версия Docker-бандла, которая соответствует минимальной версии USERSIDE, способной работать на этой версии бандла. Например, на версии Docker-бандла 3.13 может работать USERSIDE версий 3.13, 3.14, 3.15, на версии Docker-бандла 3.16 может работать USERSIDE 3.16, 3.17, а на версии бандла 3.18 может работать USERSIDE 3.18, 3.19 и т.д., пока не появится новая версия бандла для какой-то очередной версии USERSIDE.

Не путайте версию Docker-бандла с версией USERSIDE.

Большинство сложных команд в виде функций и псевдонимов помещены в файл **bundle.bash**, который необходимо подключать к сеансу оболочки перед началом работы с бандлом.

Мы рекомендуем проксировать HTTP-запросы к бандлу используя реверсивный прокси-сервер на базе NGINX — это даст возможность использовать доступ на основе доменных имен, а также испльзовать SSL и другие возможности, недоступные при использовании бандла напрямую (например, ограничение прав доступа на основе IP адресов). Но Вы можете использовать Userside в Docker-бандле и без него. Если вы решили использовать реверсивный прокси, то будет более правильным настроить его до установки Userside. Рекомендации по настройке можно найти внизу статьи в разделе «Реверсивный HTTP-прокси».

## Установка
1. Выделите доменное имя для ERP USERSIDE и создайте необходимые записи на DNS-сервере либо в файле /etc/hosts на текущем сервере, проверьте, что имя разрешается в IP-адрес корректно.
2. [Следуя инструкции, загрузите и установите](https://docs.docker.com/engine/install/) **Docker server** и плагин **Compose**. Если в Вашей операционной системе имеется Docker-IO, установленный из пакетов операционной системы, то его нужно предварительно удалить.
3. Создайте каталог, в котором будет размещаться бандл, и перейдите в него. Например:
```
sudo mkdir -p /docker && cd $_
```
4. Склонируйте этот репозиторий в подкаталог userside и перейдитие в него:
```
sudo git clone --depth 1 --branch=v3.18 https://github.com/userside/userside-docker.git userside && cd userside
```
5. Выполните команду инициализации конфигов бандла — она создаст копии образцов с рабочими именами файлов. Теперь у вас есть файлы **.env**, **compose.yaml**, **bundle.bash**.
```
sudo ./init.sh
```
6. Отредактируйте файл **.env** при помощи команды `sudo nano .env` — укажите в нем все значения переменных (путь для развёртывания файлов бандла, имя проекта и локаль, логины и пароли для служб и т.д.)
7. Необязательно, только при необходимости, внесите изменения в файлы **compose.yaml** и, если действительно нужно, в файл **bundle.bash**. Например, в файле **compose.yaml** вы можете подключить альтернативные файлы **php.ini** и **www.conf** из каталога **configs** раскомментировав соответствующие строки, а затем скопировав файлы из применов (в каталоге config) и отредактировав их в соответствии с необходимостью. Или же изменить адрес выделяемой для бандла IP-подсети. Если вы изменили адрес подсети бандла по умолчанию, то вам также необходимо изменить адреса хостов для каждого параметра списка ports в каждом сервисе. Адрес хоста — это первый адрес подсети. Помимо этого в файле **bundle.bash** необходимо также изменить значение переменной `DOCKER_HOST_IP`, указав там такой же IP-адрес хоста.
8. Подключите к текущему сеансу функции и алиасы из **bundle.bash**:
```
source bundle.bash
```
9. Запустиите установку бандла и ERP USERSIDE следующей командой и следуйте инструкциям:
```
bundle-install
```
10. Создайте WebSTOMP-пользователя для работы websocket одним из следующих способов. Пароль не обязательно должен быть слишком сложным, но и не должен быть похож ни на один из ваших паролей, так как он *передается в открытом виде* в Frontend приложение:
     1. Либо через панель управления RabbitMQ. Для этого откройте в браузере http://your.userside.net:15672 (домен замените на тот что используется для ERP USERSIDE, имя пользователя и пароль такие, как вы задали в .env файле для переменных RABBITMQ_DEFAULT_USER и RABBITMQ_DEFAULT_PASS), перейдите на вкладку **Admin**, внизу в разделе **Add a user** в качестве имени пользователя укажите имя пользователя, например, stompuser и задайте пароль. Поле с тэгами оставьте пустым. Затем нажмите **Add user**. Теперь выше в разделе **All users** кликните по только что созданному пользователю, чтобы открыть его параметры. В разделе **Permissions** для **Configure regexp** и для **Read regexp** задайте значение `^userside-stomp:id-.*`, а для **Write regexp** удалите значение, оставив поле пустым. Нажмите кнопку **Set permission**.
     2. Либо выполнив команду и следуя инструкциям:
        ```
        rabbitmq-create-stomp-user
        ```
Имя WebSTOMP-пользователя и пароль указываются в USERSIDE в меню: Настройка - Основная - Websocket. Если вы используете реверсивный прокси перед бандлом, не забудьте про `location` для `/ws` (более подробно ниже в разделе про реверсивный прокси).

## Обновление

### В пределах версий Docker-бандла 3.16 или 3.18
Для обновления ERP USERSIDE в пределах бандла версий 3.16 и 3.18 (например, с 3.16.4 на 3.16.7 или с 3.18.1 на 3.18.3) никаких дополнительных действий не требуется. Запустите команду и следуйте инструкциям:
```
bundle-update
```

### Обновление с версии Docker-бандла 3.16 на версию 3.18
Прежде чем что либо обновлять, выполните резервное копирование файлов, как обычно, и затем **обязательно** выполните резервное копирование базы данных в SQL-скрипт — он пригодится  позже:
```
source alias.bash

backup-make

mkdir -p ~/bundle_316
sudo sh -c "docker compose -p ${PROJECT_NAME} exec postgres pg_dump -U ${POSTGRES_USER} --no-acl -Fp -Z 5 ${POSTGRES_DB}" > ~/bundle_316/db_backup.sql.gz
```
Будет создана резервная копия базы данных в вашем домашнем каталоге. Убедитесь, что полученный бекап базы данных действительно представляет SQL-скрипт и имеет не нулевой размер. Только после этого переходите к следующим шагам.
```
ls -lh ~/bundle_316
```

Сохраните файлы бандла: .env, bundle.bash, docker-compose.yml (compose.yaml), Makefile в надежное место. Также сохраните файлы когфигураций из подкаталога config, если вы их изменяли. Также, если производились тонкие настройки PostgreSQL, скопируйте файл data/db/postgresql.conf. После развертывания новой версии бандла вам нужно будет настроить новые файлы бандла, скопировав значения из этих файлов.
```
sudo chmod -R +rX data/db
cp --parents {.env,bundle.bash,Makefile,docker-compose.yml,config/*,data/db/postgresql.conf} ~/bundle_316/
ls -lah ~/bundle_316
```

Сохраните в надежное место резервные копии из подкаталога data/backup.

Остановите бандл:
```
bundle-stop
```

Перед выполнением следующей команды еще раз убедитесь, что скопировали все файлы, включая резервные копии!
Эта команда остановит и удалит все контейнеры, включая все примонтированные тома:
```
${DOCKER_COMPOSE} down -v --remove-orphans
```

До выпуска стабильного релиза userside 3.18, текущая ветка Docker-бандла v3.18 также имеет стутс *Beta* и еще не влита в ветку master. По этой причине, перед обновлением, вам необходимо переключиться на ветку v3.18, а когда выйдет релиз, можно будет вернуться к ветке master:
```
sudo git fetch
sudo git checkout v3.18
sudo git pull
```

#### Конфигурационные файлы
Новая версия 3.18 бандла имеет значительные отличия по конфигурации. Если в ходе редактирования файлов конфигурации вы запутаетесь, вы всегда можете начать сначала, скопировав файлы примеров и взяв значения из резервных копий файлов конфигурации, которые вы сделали ранее.

##### файл .env
+ переменная окружения `USERSIDE_BASE_DIR` теперь называется `ERP_BASE_DIR`. Измените ее название. Также измените название этой переменной в файле compose.yaml.
+ переменные `STOMP_USER` и `STOMP_PASSWORD`, используемые ранее для Makefile (упразднен начиная с 3.18) более не нужны — их можно удалить.
Также обязательно сверьте файл `.env` с файлом-примером `.env-example` чтобы убедиться, что все переменные записаны правильно и нет недостающих или лишних переменных.
```
sudo diff .env .env-example
```

##### файл bundle.bash
Этот файл сильно изменился, поэтому мы рекомендуем скопировать его заново с файла-примера `bundle.bash-example` и внести необходимые изменения, если вы это делали. Желательно не изменять ничего в этом файле и использовать его целиком как показано в файле-примере.
```
sudo cp bundle.bash-example bundle.bash
```

##### файл compose.yaml
Если вы не изменяли файл compose.yaml (docker-compose.yml) в предыдущих версиях бандла, то лучшим выбором будет скопировать файл compose.yaml из примера:
```
sudo cp compose.yaml-example compose.yaml
```
Если измения все же выполнялись, то отредактируйте файл compose.yaml учитывая следующие изменения:
+ сервис `postgres` теперь использует Docker-образ, основанный на **postgresql 15** (до этого использовалась 11-я версия). Поэтому, перед обновлением, обязательно необходимо сделать резервную копию базы данных в SQL-скрипт, чтобы иметь возможность восстановления на 15й версии. Также у сервиса можно удалить volume `backup:/backup` — в нем больше нет необходимости, т.к. работа с резервными копиями теперь выполняется на хосте, используя сокращенные команды из `bundle.bash`.
+ сервис `poller` теперь имеет свой отдельный Docker-образ службы **usm_poller** (до этого использовалась оболочка php вместо полноценного образа службы). Скопируйте целиком весь сервис `poller` из файла-примера. Обратите внимание, что начиная с версии Userside 3.18 большая часть работы по взаимодействию со борудованием связи выполняется не самим ядром Userside, а именно внешней службой usm_poller.
+ для всех сервисов, использующих образы `erpuserside/userside:3.16-xxx` измените версию на `erpuserside/userside:3.18-xxx`.
+ измените имя переменной `USERSIDE_BASE_DIR` на `ERP_BASE_DIR`.
Также обязательно сверьте файл `compose.yaml` с файлом-примером `compose.yaml-example`.

Если вам было необходимо изменить подсеть для бандла (`subnet` в разделе настроек `networks`), то вам также необходимо обязательно изменить и IP адрес в каждом элементе списка `ports` для каждого из сервисов — здесь нужно указать IP-адрес хоста, которым является первый адрес из подсети (не считая самого адреса подсети). Например, для подсети 172.31.254.0/25 IP-адресом хоста будет 172.31.254.1. Также в файле bundle.bash необходимо изменить значение переменной `DOCKER_HOST_IP`.


#### После редактирования конфигурационных файлов
Так как файл `bundle.bash` значительно отличается от того, который был загружен вначале, перед тем как продолжить, необходимо чтобы эти изменения отразились и в сеансе оболочки. Для этого вам придется выйти из сеанса оболочки и затем войти снова. После этого загрузите обновленный файл:
```
source bundle.bash
```

Теперь нужно запустить службу postgres. Сначала убедитесь, что в `.env` указана верная локаль, имя базы данных, имя пользователя и пароль и после этого выполните:
```
${DOCKER_COMPOSE} up postgres -d
```
После запуска нового контейнера будет создана новая пустая база данных.

Если вы производили какие-то тонкие настройки в файле data/db/postgresql.conf, резервную копию которого вы сделали до начала обновления, то восстановите эти настройки в новом файле, но только ни в коем случае не копируйте старый файл от 11й версии поверх нового файла. Они имеют значительные различия.

Вообще мы рекомендуем воспользоваться калькуляторами параметров postgresql заново, чтобы рассчитать их для версии 15, ведь они могут значительно отличаться.

Теперь восстановите резервную копию в эту базу данных:
```
database-restore ~/bundle_316/db_backup.sql.gz
```
Проследите, чтобы не возникало никаких ошибок при восстановлении базы данных.

После восстановления проверьте, чтобы данные находились в базе данных, например, используя SQL-запрос:
```
psql -At -c "SELECT (value::jsonb)->'vn' FROM key_value WHERE key='installer.release'"
```
Запрос должен вернуть информацию о текущей версии Userside, которой соответствует структура базы данных.

Можно приступить к обновлению. Выполните команду обновления и следуйте инструкциям:
```
bundle-update
```

После того как обновление завершилось, необходимо заново создать WebSocket пользователя в RabbitMQ, т.к. при глобальном обновлении RabbitMQ он, скорее всего, был утерян. Чтобы узнать имя пользователя и пароль, на который настроен Userside, перейдите в интерфейсе Userside в меню Настройки - Основные - WebSocket, либо создайте новую пару имени и пароля по желанию. Создать пользователя для WebSocket в RabbitMQ можно выполнив следующую команду и в ответ на приглашения введя имя создаваемого пользователя и пароль.
```
rabbitmq-create-stomp-user
```

#### Проблемы во время обновления между версиями бандла
При возникновении проблем во время обновления с версии 3.16 на версию 3.18 инсталлятор предложит исправить ошибку и выполнить repair, однако при таком действии будет предпринята попытка восстановить предыдущую установленную версию, что будет невозможно из-за несовместимости версии PHP в бандле 3.18 и в userside предыдущих версий. Специально для таких случаев можно использовать команду:
```
bundle-update force
```
При последующих обвновлений с версии 3.18.x на 3.18.y в случае проблем используйте команду `erp-repair`.


### С версии Docker-бандла 3.12, 3.13 до версии 3.16
При обновлении ERP USERSIDE до версии 3.16 также необходимо обновить и Docker-бандл до версии 3.16. Обновленный бандл включает новый набор контейнеров, необходимый для работы фоновых процессов и брокера для управления сообщениями между ними, которые появились в ERP USERSIDE 3.16.

#### Изменения
+ Теперь все значения переменных (логины, пароли и прочее) вынесены в `.env` файл.
+ Redis теперь требует обязательной установки пароля
+ Добавлены сервисы, необходимые для работы USERSIDE 3.16 (RabbitMQ, воркер ядра, воркер поллера)

#### Порядок обновления
1. Выполните резервное копирование и остановите работу бандла:
```
backup-make && bundle-stop
```
Если используется **Makefile**, то:
```
sudo make backup && sudo make stop
```
2. Если вместо **master** вы используете ветку **v3.13**, то переключитесь на ветку **v3.16** (либо на ветку **master**, чтобы всегда получать самую последнюю стабильную версию бандла):
```
sudo git checkout v3.16
sudo git pull
```
3. Переименуйте ваш текущий файл docker-compose.yml чтобы не затереть его содержимое в процессе обновления:
```
sudo mv docker-compose.yml docker-compose_3-13.yml
```
4. Удалите файл Makefile, если вы не вносили в него никаких изменений. Иначе переменуйте и его.
```
sudo rm Makefile
```
5. Выполните команду инициализации — она создает рабочие файлы копируя шаблонные файлы примеров:
```
sudo ./init.sh
```
6. Из файла **docker-compose_3-13.yml** перенесите все значения переменных в файл **.env**. Укажите в значении переменной `USERSIDE_BASE_DIR` **полный путь** к каталогу, в котором развернут бандл (текущему каталогу). В данном примере это `/docker/userside`.
7. Начиная с версии бандла 3.16 пароль для Redis **обязателен**. Если у вас раньше не было пароля, задайте его в переменной `REDIS_PASSWORD` файла **.env**, а затем добавьте в файл **./data/userside/.env** переменную `US_REDIS_PASSWORD` с точно таким же паролем.
8. В файле `.env` имеются переменные, отвечающие за количество контейнеров, запускаемых для сервисов-обработчиков: `CORE_WORKER_NUM` и `POLLER_NUM`. По умолчанию они установлены в 10 и 5 соответственно. Если вам нужно больше обработчиков — измените эти цифры здесь. Для начала **рекомендуем оставить их по умолчанию**.
9. Запустите инсталляцию. При обновлении с версии бандла 3.13 на 3.16 нужно выполнить именно эту команду, а не **update**. В дальнейшем при обновлении в пределах версии бандла 3.16 нужно будет использовать команду обновления.
```
bundle-install
```
Если используется **Makefile**, то:
```
sudo make install
```
10. Проследите, чтобы обновление до ERP USERSIDE 3.16 прошло корректно.
11. Удалите файл **docker-compose_3-13.yml** — он больше не нужен. Если вы сохраняли файл Makefile (п.4), перенесите из него все ваши изменения в новый Makefile и удалите старый.
```
sudo rm docker-compose_3-13.yml
```

## Эксплуатация
Большинство используемых команд заключены в файле `bundle.bash` в виде псевдонимов или функций. Чтобы использовать этот набор команд, подключите этот файл к текущему сеансу оболочки выполнив команду `source bundle.bash` или ее сокращенный вариант `. bundle.bash`. Теперь вы можете вводить в командную строку команды-псевдонимы и функции из этого файла, значение которых будет описано далее.

### Список специальных команд
#### Основные команды
+ `bundle-start` — запустить Docker-бандл
+ `bundle-stop` — остановить все контейнеры бандла
+ `bundle-restart` — перезапустить бандл
+ `bundle-install` — запуск инициализации окружения для бандла, затем запуск инсталлятора для установки и после чего инициализации задач в планировщике cron и других постинсталляционных процессов
+ `erp-install` — запуск **инсталлятора** с командой *install*
+ `erp-repair` — запуск **инсталлятора** с командой *repair*
+ `bundle-update` — выполнение всех необходимых процедур для проведения обновления бандла и USERSIDE, включая предварительное резервное копирование
+ `bundle-destroy` — удаление Docker-бандла и задач планировщика cron. Файлы USERSIDE не удаляются
+ `bundle-purge` — то же самое, что и **bundle-destroy**, но также *безвозвратно удаляются* все файлы USERSIDE
+ `bundle-logs` — отображение журнала работы Docker-контейнеров. В качестве параметра можно указать имя конкретного сервиса
+ `erp-flush-cache` — очистка кэшей ядра userside
+ `backup-make` — выполнение резервного копирования файлов и базы данных

#### Вспомогательные команды
+ `psql` — запуск консольной утилиты **psql** для взаимодействия с базой данных
+ `rabbitmqctl` — запуск консольной утилиты **rabbitmqctl** для управления RabbitMQ

### Резервное копирование
Сценарием автоматического развёртывания устанавливаются и настраиваются все необходимые компоненты системы, в том числе периодическое резервное копирование (задание помещается в системный cron). Архивы размещаются в подкаталоге **data/backup** бандла.

Если Вам необходимо выполнить внеочередное резервное копирование, запустите команду:
```
backup-make
```
Будет создана резервная копия файлов и базы данных и помещена в **./data/backup**.

#### Резервное копирование базы данных
Начиная с версии Docker-бандла 3.18 резервное копирование базы данных производится в SQL-скрипт вместо Dump.

Для выполнения резервного копирования базы данных можно выполнить команду, выводящую резервную копию в стандартный вывод:
```
database-backup > database.sql.gz
```
Или просто:
```
database-backup-to-file
```
В последнем случае будет создан файл в подкаталоге data/backup имеющий стандартное имя, как и при автоматическом резервном копировании.

#### Восстановление базы данных из резервной копиии
Для восстановления базы данных из резервной копии в виде SQL-скрипта испльзуется команда:
```
database-restore data/backup/userside_db_2023-04-07_16-25.sql.gz
```

### Службы, работающе в фоне и брокер RabbitMQ
Для мониторинга состояния брокера RabbitMQ используется модуль **RabbitMQ management** WEB-интерфейс которого доступен по адресу http://your.userside.net:15672 (домен замените на тот что используется для ERP USERSIDE, имя пользователя и пароль такие, как вы задали в **.env** файле для переменных `RABBITMQ_DEFAULT_USER` и `RABBITMQ_DEFAULT_PASS`).

Если фоновые задания постоянно выполняются с большой задержкой, вам следует обратить внимание на загруженность очередей (на вкладке Queues) и если очереди постоянно или довольно часто и подолгу содержат относительно большое количество сообщений, вы можете изменить количество запускаемых экземпляров фоновых процессов для каждой из них:

Очередь **erp.core** отвечает за сообщения, передаваемые обработчику ядра. Количество экземпляров этого обработчика можно задать в переменной окружения `CORE_WORKER_NUM` в файле **.env** бандла (не userside).

Очередь **usm_poller** отвечает за сообщения, передаваемые модулю поллера, который выполняет операции по взаимодействию с оборудованием. Количество экземпляров поллера можно задать в переменной окружения `POLLER_NUM` в файле **.env** бандла (не userside).

Если значения для этих переменных изменялись, необходимо перезагрузить бандл:
```
bundle-restart
```

## Тонкая настройка
Для достижения максимальной производительности рекомендуется произвести тонкую настройку окружения. Принципы описаны [на нашей специальной wiki-странице](https://wiki.userside.eu/Tuning).

### PHP и FPM
Изменять настройки для служб Docker-бандла можно при помощи подключаемых через тома (volumes) файлов. В файле **compose.yaml** для служб **php**, **fpm** имеются закомментированные тома для файлов, в которых можно разместить дополнительные опции для тонкой настройки.

Скопируйте файлы php.ini-example и www.conf-example в подкаталоге config в файлы php.ini и www.conf соответственно и отредактируйте их. Затем ракомментируйте соответствующие тома (volumes) в службах php и fpm файла compose.yaml и перезапустите бандл:
```
bundle-restart
```

### PostgreSQL
Файлы конфигурации PostgreSQL находятся в подкаталоге data/db и могут быть отредактированы прямо там. После редактирования нужно так же перезапустить бандл:
```
bundle-restart
```

## Использование дополнительных модулей USERSIDE
Файл compose.yaml содержит службу **usm_billing** представляющую собой реализацию модуля взаимодействия с биллинговыми системами. Эта служба добавлена в качестве примера и если в ней нет необходимости, может быть удалена из конфигурации. Если же Вы используете этот модуль, то Вам необходимо заполнить основные параметры в блоке `environment` этой службы: `USERSIDE_API_KEY`, `BILLING_NAME`, `BILLING_URL`, `BILLING_ID`. Остальные параметры — по необходимости. Параметр `USERSIDE_API_URL` в случае использования внутри бандла заполнять не нужно: имя сервера подставится автоматически.

[В нашем репозитории](https://github.com/orgs/userside/repositories) вы можете найти примеры использования в Docker других модулей. Примеры содержат фрагмент конфигурации бандла, который можно использовать в файле compose.yaml вашего бандла и пошаговую инструкцию по установке и настройке модуля внутри бандла.

Если для интересующего Вас модуля нет подобного примера использования, Вы можете создать его самостоятельно на примере других модулей.

## Использование нескольких бандлов на одном сервере
При необходимости использования нескольких копий USERSIDE на одном сервере, необходимо организовать несколько бандлов — по одному на каждую копию. Если основной каталого, в котором планируется разместить все бандлы, является `/docker` (согласно этой инструкции), и, например, нужно использовать две отдельных копии USERSIDE, то проделайте следующее.

### Установка
#### Развёртывание
Создайте каталог `/docker`, если он еще не создан, и перейдите в него:
```
sudo mkdir -p /docker && cd $_
```

Склонируйте репозиторий дважды. Указывайте понятное имя для каждого бандла, чтобы в будущем точно знать где какой:
```
sudo git clone --depth 1 https://github.com/userside/userside-docker.git userside-production
sudo git clone --depth 1 https://github.com/userside/userside-docker.git userside-testing
```
В результате вы получите два каталога: /docker/userside-production и /docker/userside-testing в каждом из которых будет размещаться своя версия бандла.

#### Конфигурирование
Перейдите в каждый из каталогов и выполните инициализацию:
```
cd /docker/userside-production && sudo ./init.sh
cd /docker/userside-testing && sudo ./init.sh
```

##### Файл .env
Теперь отредактируйте файл `.env` в каждом из каталогов бандлов. Вам необходимо обязательно указать абсолютный путь к бандлу (переменная `ERP_BASE_DIR`) и имя проекта (переменная `PROJECT_NAME`), например, **userside-production** и **userside-testing**.

При необходимости измените остальные переменные. Например, для тестовой копии USERSIDE вовсе не обязательно запускать 10 копий core_worker процессов и также не обязательно запускать 5 копий микросервисов поллеров. Для тестовой копии будет достаточно по одной копии, так как нагрузка на тестовую копию предполагается минимальной.

##### Файл compose.yaml
Теперь необходимо внести измение в файл настройки бандла `compose.yaml`. Здесь необходимо изменить только настройки, касающиеся сети. Бандлы должны использовать разные подсети, а размер подсети должен быть достаточным, чтобы уместить все контейнеры бандла с некоторым запасом.

По умолчанию в примере этого файла используется подсеть 172.31.254.0/25. Если эта подсеть подходит Вам (не пересекается с имеющимися подсетями на предприятии), то оставьте ее такой в одном из бандлов, а во втором измените на, например, 172.31.254.128/25. Для этого в блоке настроек **networks** необходимо изменить значение для параметра **subnet**.

Первый адрес узла из каждой подсети будет отдан интерфейсу хоста, а остальные случайным образом назначены контейнерам бандла. В данном примере IP-адреса 172.31.254.1 и 172.31.254.129 будут назначены интерфейсам bridgeXXX на хосте. Эти адреса удобно использовать для трансляции портов контейнеров.

Просмотрите внимательно параметр **ports** всех служб (services) в compose.yaml. Он содержит список портов, которые необходимо транслировать для каждого из сервисов. Например, запись `"172.31.254.1:8080:80"` для службы **nginx** означает, что порт 8080 интерфейса с адресом 172.31.254.1 на хосте должен транслироваться на порт 80 внутри контейнера с nginx. Это позволяет получить сетевой доступ внутрь бандла к контейнеру, обращаясь к IP адресу хоста.

Измените адреса так, чтобы ими были адреса первых узлов в соответствующей подсети. Для описываемого примера это 127.31.254.1 для первого бандла и 172.31.254.129 для второго бандла.

Также в файлах bundle.bash необходимо изменить значение переменной `DOCKER_HOST_IP` на соответствующее конкретному IP-адресу хоста.

Удалите комментарий со строки, транслирующей порт WebSTOMP с номером 15674 сервиса rabbitmq. Это нужно сделать при использовании реверсивного прокси перед бандлом.

### Реверсивный HTTP-прокси
Мы рекомендуем использовать реверсивный прокси даже если у вас на сервере одна копия Usersdide. Это позволяет более гибко настроить web доступ. Например, использовать SSL либо настроить необходимые права доступа. Но если для одного бандла реверсивный прокси не всегда необходим, но при использовании двух и более бандлов его необходимость практически безоговорочна.

![Два бандла с одним реверсивным прокси](/img/nginx.png)

Установите NGINX и настройте его как реверсивный прокси следующим способом. В примере используются имена доменов **userside.company.net** для рабочей копии userside и **test-us.company.net** для тестовой копии userside. Если у вас одна копия, используйте один блок `server`. Пример:
```
server {
    listen 80;
    server_name userside.company.net;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://172.31.254.1:8080;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
    }

    location /ws {
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_pass http://172.31.254.1:15674/ws;
        proxy_http_version 1.1;
    }
}

server {
    listen 80;
    server_name test-us.company.net;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://172.31.254.129:8080;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
    }

    location /ws {
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_pass http://172.31.254.129:15674/ws;
        proxy_http_version 1.1;
    }
}
```

## Дополнения и исправления
Будем благодарны за обратную связь, предложения и сообщения о найденых ошибках в данном Docker-окружении для USERSIDE. О них Вы можете сообщать через Issue систему этого репозитория. Также будем рады предложениям и исправлениям в виде Poll Request.