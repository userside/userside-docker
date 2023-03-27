[![en](https://img.shields.io/badge/lang-en-green.svg)]
[![ru](https://img.shields.io/badge/lang-ru-yellow.svg)]

# ERP USERSIDE Docker Bundle v3.16.11 (EN)

## About the project
This project is a **sample set** of configuration files and scripts to run the **Docker bundle** of the system ERP USERSIDE. All the images required for ERP USERSIDE are already built with all the necessary dependencies, settings and are located in [Docker HUB](https://hub.docker.com/repository/docker/erpuserside/userside). You can build your own bundle from these samples using Docker [Compose](https://docs.docker.com/compose/) or by using other orchestration tools that you are comfortable with. You can also use the samples as is and get a working ERP USERSIDE system without any additional steps. We rely entirely on your understanding of containerisation in Linux, Docker, Docker Compose, Swarm and the other systems you intend to use.

These sample of Docker-environments are distributed "as is" without any guarantee. We also do not provide technical support for the installation, configuration and maintenance of Docker and related tools. If you are not familiar with Docker, you should use the classic example of installing ERP USERSIDE on a Linux server.

Within these instructions, the version of the Docker bundle that corresponds to the minimum USERSIDE version capable of running on that version of the bundle is used. For example, on Docker-bundle version 3.13 may work USERSIDE versions 3.13, 3.14, 3.15 and on Docker-bundle version 3.16 may work USERSIDE 3.16, 3.17, etc., until a new version of the bundle will be available for some other version of USERSIDE.

Do not confuse the Docker bundle version with the USERSIDE version.

Most complex commands are placed in the **Makefile** as macros and can be called via the `make macros_name` command if a **build-essential** package is available on the system. Since the Docker bundle 3.16.9 this method has been declared obsolete and a more convenient method in the form of bash functions has been added to replace it, which are added to the session from **bundle.bash** file. Both methods work the same for now, but in future versions the **Makefile** method will be removed.

We recommend proxying HTTP to the bundle using the NGINX reverse proxy — it will make it possible to use access based on domain names, as well as using SSL and other features, not available when using the bundle directly (e.g. restricted access rights based on IP addresses). But you can use Userside in the Docker bundle without it. If you choose to use a reverse proxy, it is more appropriate to set it up before installing Userside. Recommendations on setting up can be found at the bottom of the article under "Reverse HTTP Proxy".

## Installation
1. Allocate a domain name for ERP USERSIDE and create the necessary entries in the DNS server or file /etc/hosts on the current server, check that the name resolves to the IP address correctly.
2. Download and [install](https://docs.docker.com/engine/install/) **Docker server** and a plug-in **Compose**.
3. Create a directory where the bundle will be located and navigate to it. For example:
```
sudo mkdir -p /docker && cd $_
```
4. Clone this repository into the userside subdirectory and navigate to it:
```
sudo git clone --depth 1 https://github.com/userside/userside-docker.git userside && cd userside
```
5. Execute the initialisation command for the bundle configurations — it will create copies of the samples with working file names. Now you have files **.env**, **compose.yaml**, **bundle.bash**, **Makefile**.
```
sudo ./init.sh
```
6. Edit the file **.env** by using the command `sudo nano .env` — specify all variable values in it (path to deploy the bundle files, project name, time zone and locale, logins and passwords for services, etc.)
7. Optional, only if necessary, make changes to the files **compose.yaml** and if really necessary into the files **bundle.bash** and **Makefile**. For example, in the file **compose.yaml** you can plug in alternative files **php.ini** and **www.conf** from the directory **configs** by uncommenting the relevant lines and then copying the files from the examples (in the config directory) and editing them as necessary. Alternatively, change the IP-subnet address allocated to the bundle.
8. Connect functions and aliases from **bundle.bash**. Instead of `.` you can use the `source` command. A space after the dot:
```
. bundle.bash
```
9. Start the installation of the bundle and ERP USERSIDE with the following command and follow the instructions:
```
bundle-install
```
If used a **Makefile**, then:
```
sudo make install
```
10. If used a **Makefile**, the bundle must be restarted after installation, to run all background processes correctly. If **bundle.bash** was used, this step should be skipped:
```
sudo make restart
```
11. Create a WebSTOMP-user for websocket operation in one of the following ways. The password does not have to be too complex, but it does not have to be similar to any of your passwords, as it is transmitted in plain text to the Frontend application:
     1. Either through the RabbitMQ control panel. To do this, open in your browser http://your.userside.net:15672 (change the domain to the one used for ERP USERSIDE, username and password as you have set in the .env file for RABBITMQ_DEFAULT_USER and RABBITMQ_DEFAULT_PASS variables), click on the tab **Admin**, at the bottom of **Add a user** enter a user name as the user name, e.g. stompuser and set a password. Leave the tag field blank. Then press **Add user**. Now above in the section **All users** click on the newly created user, to open its parameters. In the section **Permissions** for the **Configure regexp** and for the **Read regexp** set the value `^userside-stomp:id-.*`, and for the **Write regexp** delete the value, leaving the field blank. Press the button **Set permission**.
     2. Or by running the command and following the instructions:
        ```
        rabbitmq-create-stomp-user
        ```
        If using **Makefile**, run the following command (specify your values instead of `stompuser` and `password`):
        ```
        sudo make STOMP_USER="stompuser" STOMP_PASSWORD="password" rabbitmq-create-stomp-user
        ```
The WebSTOMP user name and password are specified in USERSIDE in the menu: SETTINGS - MAIN - Websocket.

## Updating
### Within the Docker bundle version 3.16
No further action is required to update the ERP USERSIDE within the 3.16 bundle. Run the command and follow the instructions:
```
bundle-update
```
If used **Makefile**, then:
```
sudo make update
```

### From Docker bundle version 3.12, 3.13 to version 3.16
When upgrading ERP USERSIDE to version 3.16, the Docker bundle must also be upgraded to version 3.16. The upgraded bundle includes a new set of containers required for background processes and a broker to manage the messages between them, which appeared in ERP USERSIDE 3.16.

#### Changes
+ All variable values (logins, passwords, etc.) are now placed in the `.env' file.
+ Redis now requires a password to be set
+ Added services required for USERSIDE 3.16 (RabbitMQ, kernel worker, poller worker)

#### Upgrading procedure
1. Back up and stop the bundle:
```
backup-make && bundle-stop
```
If used **Makefile**, then:
```
sudo make backup && sudo make stop
```
1. If you use branch **v3.13** instead of **master**, then switch to branch **v3.16** (or on the **master** branch to always get the latest stable version of the bundle):
```
sudo git checkout v3.16
sudo git pull
```
3. Rename your current docker-compose.yml file so that its contents are not overwritten by the upgrade process:
```
sudo mv docker-compose.yml docker-compose_3-13.yml
```
4. Delete the Makefile file if you have not made any changes to it. Otherwise change it too.
```
sudo rm Makefile
```
5. Run the initialisation command - it creates working files by copying the example template files:
```
sudo ./init.sh
```
6. From **docker-compose_3-13.yml** file, transfer all variable values to **.env**. Specify in the `USERSIDE_BASE_DIR` variable the **full path** to the directory where the bundle is deployed (current directory). In this example it is `/docker/userside`.
7. From version 3.16 of the bundle, the password for Redis is **mandatory**. If you did not have a password before, set it in the `REDIS_PASSWORD` variable in **.env**, and then add to **./data/userside/.env** the variable `US_REDIS_PASSWORD` with the exact same password.
8. The `.env` file contains variables responsible for the number of containers to run for the handler services: `CORE_WORKER_NUM` and `POLLER_NUM`. By default they are set to 10 and 5 respectively. If you need more handlers - change these numbers here. To start with **we recommend leaving them as default**.
9. Start the installation. When upgrading from version 3.13 to 3.16, this is the command you need to run, not **update**. In future updates within the 3.16 bundle version will need to use the update command.
```
bundle-install
```
If used **Makefile**, then:
```
sudo make install
```
10. Ensure that the upgrade to ERP USERSIDE 3.16 goes correctly.
11. Delete the file **docker-compose_3-13.yml** — it is no longer needed. If you have saved a Makefile (step 4), transfer all your changes from it to the new Makefile and delete the old one.
```
sudo rm docker-compose_3-13.yml
```

## Exploitation
As of version 3.16.9 of the Docker bundle, entering special commands using macros from **Makefile** is declared obsolete, but you can still use it. In place of this method, a new way of entering special commands has been added - using Bash aliases and interpreter functions, which are placed in the `bundle.bash` file. The new method is more user-friendly and does not require additional packages to be installed on the system.

To use the new method with Bash aliases and functions, you need to connect these functions to the current shell script, using the `source bundle.bash` command or its shortened version `. bundle.bash`. Then simply enter the command at the command line, as usual.

To use macros from **Makefile**, the **build-essential** package is required. To execute a macro, its name must be passed to the `make` command, which must be executed with an escalation (via `sudo`). For example: `sudo make install`.

### List of special commands
To the right in parentheses is the name of the macro to be used with `sudo make` e.g. `sudo make up`.
#### Main commands
+ `bundle-start` — run a Docker-bundle (`up`)
+ `bundle-stop` — stop all bundle containers (`down` or `stop`)
+ `bundle-restart` — restart the bundle (`restart`)
+ `bundle-install` — running environment initialisation for the bundle, then running the installer to install and then initialising tasks in the cron scheduler and other post-installation processes (`install`)
+ `userside-install` — running the **installer** with the command *install* (`userside-install`)
+ `userside-repair` — running the **installer** with the *repair* command (`userside-repair`)
+ `bundle-update` — Perform all necessary procedures to make updates to the bundle and USERSIDE, including an initial backup (`update`)
+ `bundle-destroy` — removing the Docker-bundle and cron scheduler tasks. USERSIDE files are not removed (`uninstall`)
+ `bundle-purge` — same as **bundle-destroy**, but also *removes* all USERSIDE files (`purge`)
+ `bundle-logs` — displaying the Docker container log. A specific service name can be given as a parameter (`log`)
+ `userside-flush-cache` — clearing of caches and queues (`flush`)
+ `backup-make` — backup execution (`backup`)
+ `backup-restore-db` — restore the database from backup (`dbrestore` see below for how to use)

#### Auxiliary commands
+ `bundle-pgsql` — running the console utility **psql** to interact with the database (`postgres-psql`)
+ `bundle-pg-postgis-update` — run a PostGis version update, in case it is required after a USERSIDE update.
+ `bundle-rabbitctl` — running the console utility **rabbitmqctl** to control RabbitMQ
+ `rabbitmq-cleanup` — RabbitMQ queue cleanup (`rabbitmq-cleanup`)


#### Other commands
There are actually more aliases and functions in the file. The main alias is `docker_compose`, which can be used as normal `sudo docker compose`, but it already has all the necessary parameters prescribed, making it easy to use. All other commands are based on this alias. You can examine the **bundle.bash** file and even add your own commands if necessary. The **bundle.bash** file is not overwritten when the bundle is updated via `git pull` - there is an example file **bundle.bash-example** which is maintained by developers and can be changed. You can propose commands via pool-request to this repository.

### Backup
The auto-deployment script installs and configures all necessary system components, including periodic backups (the task is placed in the system cron). The archives are placed in the **data/backup** subdirectory of the bundle.

If you need to perform an unscheduled backup, run the command:
```
backup-make
```
If used **Makefile**, then:
```
sudo make backup
```
Files and database will be backed up and placed in **./data/backup**.

#### Recovery
To restore the database from a backup, use the command:
```
backup-restore-db
```
On starting it, you will be prompted for the *file name* of the database dump (no path) from the **./data/backup** directory.

To restore a backup using **Makefile**, pass in the *file name* (no path) via an environment variable, located in subdirectory **./data/backup**, from which you want to restore. For example:
```
sudo make DUMP="userside_2019-05-08_09-23-19.dump" dbrestore
```

### Background processes and RabbitMQ
To monitor the RabbitMQ broker status, the **RabbitMQ management** module is used, the WEB interface of which is available at http://your.userside.net:15672 (replace domain with the one used for ERP USERSIDE, username and password as you set in **.env** file for variables `RABBITMQ_DEFAULT_USER` and `RABBITMQ_DEFAULT_PASS`).

If background jobs run with a long delay, you should pay attention to the load of the queues (on the Queues tab) and if the queues consistently or fairly often contain a relatively large number of messages, you can change the number of running instances of background processes for each of them.

The **userside** queue is responsible for messages sent to the kernel handler. The number of instances of this handler can be set in the environment variable `CORE_WORKER_NUM` in the **.env** bundle file (not userside).

The **network_poller** queue is responsible for messages sent to the poller microservice, which performs hardware communication operations. The number of instances of this microservice can be set in the environment variable `POLLER_NUM` in the **.env** bundle file (not userside).

If the values for these variables have changed, the bundle must be reloaded:
```
bundle-restart
```
If used **Makefile**, then:
```
sudo make restart
```

## Fine-tuning
For maximum performance, we recommend performing some fine-tuning of the environment. The principles are covered [on our special wiki page](https://wiki.userside.eu/Tuning).

### PHP и FPM
You can change the settings for Docker bundle services by using (volumes) files. The **compose.yaml** file for **php**, **fpm** services has commented out volumes for files where additional fine-tuning options can be placed.

Copy the php.ini-example and www.conf-example files in the config subdirectory to the php.ini and www.conf files respectively and edit them. Then uncomment the relevant volumes in the php and fpm services of the compose.yaml file and restart the bundle:
```
bundle-restart
```
If used **Makefile**, then:
```
sudo make restart
```

### PostgreSQL
PostgreSQL configuration files are in the data/db subdirectory and can be edited right there. After editing, you must also restart the bundle:
```
bundle-restart
```
If used **Makefile**, then:
```
sudo make restart
```

## Using additional USERSIDE modules
The compose.yaml file contains the **usm_billing** service which is an implementation of the billing module. This service is added as an example and can be removed from the configuration if it is not needed. If you are using this module, you will need to fill in the basic parameters in the `environment` block of this service: `USERSIDE_API_KEY`, `BILLING_NAME`, `BILLING_URL`, `BILLING_ID`. The other parameters as required. The `USERSIDE_API_URL` parameter does not need to be filled in if used inside the bundle: the server name will be filled in automatically.

[In our repository](https://github.com/orgs/userside/repositories) you can find examples of the use of other modules in Docker. The examples contain a fragment of the configuration of the bundle, which can be used in the compose.yaml file of your bundle, and step-by-step instructions on how to install and configure the module within the bundle.

If there is no similar use case for the module you are interested in, You can create one yourself using the example of other modules.

## Using multiple bundles on one server
If more than one USERSIDE copy needs to be used on one server, multiple bundles need to be organised - one for each copy. If the main directory in which you plan to host all the bundles is `/docker` (as per these instructions), and for example you want to use two separate copies of USERSIDE, then do the following.

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
As a result, you will have two directories: /docker/userside-production and /docker/userside-testing, each of which will host a different version of the bundle.

#### Configuration
Navigate to each of the directories and initialise:
```
cd /docker/userside-production && sudo ./init.sh
cd /docker/userside-testing && sudo ./init.sh
```

##### File .env
Now edit the `.env` file in each of the bundle directories. You must to specify the absolute path to the bundle (the `USERSIDE_BASE_DIR` variable) and the project name (the `PROJECT_NAME` variable), e.g. **userside-production** and **userside-testing**.

If necessary, change the other variables. For example, for a test copy of USERSIDE it is not necessary to run 10 copies of core_worker processes and neither is it necessary to run 5 copies of poller microservices. One copy at a time will be sufficient for the test copy, as the load on the test copy is expected to be minimal.

##### Compose.yaml file
You must now make a change to the `compose.yaml` bundle configuration file. Only the settings relating to the network need to be changed here. The bundles should use different subnets and the size of the subnet should be enough to fit all the containers in the bundle with some margin.

The default subnet in the example file is 172.31.254.0/25. If this subnet suits you (does not overlap with existing subnets in the enterprise), leave it as it is in one of the bundles, and change it to e.g. 172.31.254.128/25 in the second. To do this, change the value for **subnet** in the **networks** settings block.

The first node address from each subnet will be given to the host interface and the rest will be randomly assigned to bundle containers. In this example, IP addresses 172.31.254.1 and 172.31.254.129 will be assigned to the bridgeXXX interfaces on the host. These addresses are useful for translating container ports.

Review carefully the **ports** parameter of all services in compose.yaml. It contains a list of ports to be broadcast for each of the services. For example, the entry `"172.31.254.1:8080:80"` for the **nginx service** means that port 8080 on the 172.31.254.1 interface on the host should be translated to port 80 inside the container with nginx. This allows network access inside the bundle to the container by accessing the IP address of the host.

Change the addresses so that they are the addresses of the first nodes in the relevant subnet. For the example described, 127.31.254.1 for the first bundle and 172.31.254.129 for the second bundle.

Remove the comment from the line broadcasting the WebSTOMP port number 15674 of the rabbitmq service. This should be done when using a reverse proxy before the bundle.

### HTTP reverse proxy
We recommend using a reverse proxy even if you have one copy of Usersdide on your server. This provides more flexible web access. For example, use SSL or set up the necessary access rights. But while a reverse proxy may not always be necessary for a single bundle, it is almost certainly necessary for two or more bundles.

![Two bundles with a single reverse proxy](/img/nginx.png)

Install NGINX and configure it as a reverse proxy as follows. The example uses domain names **userside.company.net** for the userside working copy and **test-us.company.net** for the userside test copy. If you have one copy, use one `server` block. An example:
```
server {
    listen 80;
    server_name userside.company.net;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://172.31.254.1:8080;
        proxy_send_timeout 240;
        proxy_read_timeout 240;
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
        proxy_send_timeout 240;
        proxy_read_timeout 240;
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
Feedback, suggestions and bug reports on this Docker environment for USERSIDE would be appreciated. You can report them through the Issue system of this repository. Suggestions and corrections in the form of a Poll Request are also welcome.

---

# ERP USERSIDE Docker Bundle v3.16.11 (RU)

## О проекте
Данный проект представляет собой **набор образцов** конфигурационных файлов и скриптов для запуска **Docker-бандла** системы ERP USERSIDE. Все необходимые для работы ERP USERSIDE образы уже собраны со всеми необходимыми зависимостями и настройками и размещены в [Docker HUB](https://hub.docker.com/repository/docker/erpuserside/userside). Вы можете на основе данных образцов собрать свой бандл, используя Docker [Compose](https://docs.docker.com/compose/) либо испльзуя другие, удобные вам, инструменты оркестрации. Вы также можете воспользоваться образцами как есть и получить работающую систему ERP USERSIDE без каких либо дополнительных действий. Мы полностью полагаемся на ваше понимание работы контейнеризации в Linux, работы Docker, Docker Compose, Swarm и других систем, которые вы собираетесь использовать.

Данные образцы Docker-окружения распространяются «как есть» без каких либо гарантий. Мы также не оказываем техническую поддержку по вопросам установки, настройки и обслуживания Docker и связанных с ним инструментов. Если вы не знакомы с Docker, то вам следует воспользоваться классическим примером установки ERP USERSIDE на Linux-сервер.

В пределах этой инструкции используется версия Docker-бандла, которая соответствует минимальной версии USERSIDE, способной работать на этой версии бандла. Например, на версии Docker-бандла 3.13 может работать USERSIDE версий 3.13, 3.14, 3.15, а на версии Docker-бандла 3.16 может работать USERSIDE 3.16, 3.17 и т.д., пока не появится новая версия бандла для какой-то очередной версии USERSIDE.

Не путайте версию Docker-бандла с версией USERSIDE.

Большинство сложных команд помещены в файл **Makefile** в виде макросов и при наличии в системе пакета **build-essential** могут вызываться через команду `make имя_макроса`. Начиная с версии Docker-бандла 3.16.9 такой способ объявлен как устаревший и на замену был добавлен более удобный способ в виде функций bash, которые добавляются в сеанс из файла **bundle.bash**. Оба способа пока что работают одинаково, но в последующих версиях способ с **Makefile** будет удален.

Мы рекомендуем проксировать HTTP к бандлу используя реверсивный прокси NGINX — это даст возможность использовать доступ на основе доменных имен, а также испльзовать SSL и другие возможности, недоступные при использовании бандла напрямую (например, ограничение прав доступа на основе IP адресов). Но Вы можете использовать Userside в Docker-бандле и без него. Если вы решили использовать реверсивный прокси, то будет более правильным настроить его до установки Userside. Рекомендации по настройке можно найти внизу статьи в разделе «Реверсивный HTTP-прокси».

## Установка
1. Выделите доменное имя для ERP USERSIDE и создайте необходимые записи на DNS-сервере либо в файле /etc/hosts на текущем сервере, проверьте, что имя разрешается в IP-адрес корректно.
2. Загрузите и [установите](https://docs.docker.com/engine/install/) **Docker server** и плагин **Compose**.
3. Создайте каталог, в котором будет размещаться бандл, и перейдите в него. Например:
```
sudo mkdir -p /docker && cd $_
```
4. Склонируйте этот репозиторий в подкаталог userside и перейдитие в него:
```
sudo git clone --depth 1 https://github.com/userside/userside-docker.git userside && cd userside
```
5. Выполните команду инициализации конфигов бандла — она создаст копии образцов с рабочими именами файлов. Теперь у вас есть файлы **.env**, **compose.yaml**, **bundle.bash**, **Makefile**.
```
sudo ./init.sh
```
6. Отредактируйте файл **.env** при помощи команды `sudo nano .env` — укажите в нем все значения переменных (путь для развёртывания файлов бандла, имя проекта, часовой пояс и локаль, логины и пароли для служб и т.д.)
7. Необязательно, только при необходимости, внесите изменения в файлы **compose.yaml** и, если действительно нужно, в файлы **bundle.bash** и **Makefile**. Например, в файле **compose.yaml** вы можете подключить альтернативные файлы **php.ini** и **www.conf** из каталога **configs** раскомментировав соответствующие строки, а затем скопировав файлы из применов (в каталоге config) и отредактировав их в соответствии с необходимостью. Или же изменить адрес выделяемой для бандла IP-подсети.
8. Подключите функции и алиасы из **bundle.bash**. Вместо `.` можно использовать команду `source`. После точки — пробел:
```
. bundle.bash
```
9. Запустиите установку бандла и ERP USERSIDE следующей командой и следуйте инструкциям:
```
bundle-install
```
Если используется **Makefile**, то:
```
sudo make install
```
10. Если испльзовался **Makefile**, то после установки необходимо перезапустить бандл, чтобы запустить корректно все фоновые процессы. Если использовался **bundle.bash**, то этот шаг нужно пропустить:
```
sudo make restart
```
11. Создать WebSTOMP-пользователя для работы websocket одним из следующих способов. Пароль не обязательно должен быть слишком сложным, но и не должен быть похож ни на один из ваших паролей, так как он передается в открытом виде в Frontend приложение:
     1. Либо через панель управления RabbitMQ. Для этого откройте в браузере http://your.userside.net:15672 (домен замените на тот что используется для ERP USERSIDE, имя пользователя и пароль такие, как вы задали в .env файле для переменных RABBITMQ_DEFAULT_USER и RABBITMQ_DEFAULT_PASS), перейдите на вкладку **Admin**, внизу в разделе **Add a user** в качестве имени пользователя укажите имя пользователя, например, stompuser и задайте пароль. Поле с тэгами оставьте пустым. Затем нажмите **Add user**. Теперь выше в разделе **All users** кликните по только что созданному пользователю, чтобы открыть его параметры. В разделе **Permissions** для **Configure regexp** и для **Read regexp** задайте значение `^userside-stomp:id-.*`, а для **Write regexp** удалите значение, оставив поле пустым. Нажмите кнопку **Set permission**.
     2. Либо выполнив команду и следуя инструкциям:
        ```
        rabbitmq-create-stomp-user
        ```
        Если используется **Makefile**, то выполните следующую команду (вместо `stompuser` и `password` укажите ваши значения):
        ```
        sudo make STOMP_USER="stompuser" STOMP_PASSWORD="password" rabbitmq-create-stomp-user
        ```
Имя WebSTOMP-пользователя и пароль указываются в USERSIDE в меню: Настройка - Основная - Websocket.

## Обновление
### В пределах версии Docker-бандла 3.16
Для обновления ERP USERSIDE в пределах бандла версии 3.16 никаких дополнительных действий не требуется. Запустите команду и следуйте инструкциям:
```
bundle-update
```
Если используется **Makefile**, то:
```
sudo make update
```

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
1. Если вместо **master** вы используете ветку **v3.13**, то переключитесь на ветку **v3.16** (либо на ветку **master**, чтобы всегда получать самую последнюю стабильную версию бандла):
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
Начиная с версии Docker-бандла 3.16.9 ввод специальных команд используя макросы из **Makefile** объявлен устаревшим, но Вы все еще можете использовать его. Взамен этого способа добавлен новый способ ввода специальных команд — используя псевдонимы и функции интерпретатора Bash, которые помещены в файл `bundle.bash`. Новый способ является более удобным для работы и не требует установки дополнительных пакетов в систему.

Для использования нового способа с псевдонимами и функциями Bash, необходимо подключить эти функции к текущему сценарию оболочки, используя команду `source bundle.bash` или ее сокращенный вариант `. bundle.bash`. После чего в командную строку просто вводится команда, как обычно.

Для использования макросов из **Makefile** необходимо наличие пакета **build-essential**. Чтобы исполнить макрос, необходимо передавать его имя команде `make` которая должна исполняться с повышением (через `sudo`). Например: `sudo make install`.

### Список специальных команд
Справа в круглых скобках указывается наименование макроса для использования вместе с `sudo make` например, `sudo make up`.
#### Основные команды
+ `bundle-start` — запустить Docker-бандл (`up`)
+ `bundle-stop` — остановить все контейнеры бандла (`down` или `stop`)
+ `bundle-restart` — перезапустить бандл (`restart`)
+ `bundle-install` — запуск инициализации окружения для бандла, затем запуск инсталлятора для установки и после чего инициализации задач в планировщике cron и других постинсталляционных процессов (`install`)
+ `userside-install` — запуск **инсталлятора** с командой *install* (`userside-install`)
+ `userside-repair` — запуск **инсталлятора** с командой *repair* (`userside-repair`)
+ `bundle-update` — выполнение всех необходимых процедур для проведения обновления бандла и USERSIDE, включая предварительное резервное копирование (`update`)
+ `bundle-destroy` — удаление Docker-бандла и задач планировщика cron. Файлы USERSIDE не удаляются (`uninstall`)
+ `bundle-purge` — то же самое, что и **bundle-destroy**, но также *безвозвратно удаляются* все файлы USERSIDE (`purge`)
+ `bundle-logs` — отображение журнала работы Docker-контейнеров. В качестве параметра можно указать имя конкретного сервиса (`log`)
+ `userside-flush-cache` — очистка кэшей и очередей (`flush`)
+ `backup-make` — выполнение резервного копирования (`backup`)
+ `backup-restore-db` — восстановление базы данных из резервной копии (`dbrestore` см. ниже как использовать)

#### Вспомогательные команды
+ `bundle-pgsql` — запуск консольной утилиты **psql** для взаимодействия с базой данных (`postgres-psql`)
+ `bundle-pg-postgis-update` — запуск обновления версии PostGis, если это вдруг требуется после обвновления USERSIDE.
+ `bundle-rabbitctl` — запуск консольной утилиты **rabbitmqctl** для управления RabbitMQ
+ `rabbitmq-cleanup` — очистка очередей RabbitMQ (`rabbitmq-cleanup`)


#### Другие команды
На самом деле псевдонимов и функций в файле больше. Основной псевдоним — это `docker_compose`, который можно использовать как обычный `sudo docker compose`, но в нем уже прописаны все необходимые параметры, что упрощает использование. На базе этого псевдонима построены и все остальные команды. Вы можете изучить файл **bundle.bash** и даже дополнить своими командами при необходимости. Файл **bundle.bash** не затирается при обновлении бандла через `git pull` — для этого существует файл с примером **bundle.bash-example**, который поддерживается разработчиками и может изменяться. Вы можете предлагать свои варианты команд через pool-request к этому репозиторию.

### Резервное копирование
Сценарием автоматического развёртывания устанавливаются и настраиваются все необходимые компоненты системы, в том числе периодическое резервное копирование (задание помещается в системный cron). Архивы размещаются в подкаталоге **data/backup** бандла.

Если Вам необходимо выполнить внеочередное резервное копирование, запустите команду:
```
backup-make
```
Если используется **Makefile**, то:
```
sudo make backup
```
Будет создана резервная копия файлов и базы данных и помещена в **./data/backup**.

#### Восстановление
Для восстановления базы данных из резервной копии испльзуется команда:
```
backup-restore-db
```
При ее запуске будет предложено ввести *имя файла* дампа базы данных (без пути) из каталога **./data/backup**.

Для восстановления резервной копии используя **Makefile** необходимо через переменную окружения передать *имя файла* (без пути), находящегося в подкаталоге **./data/backup**, из которого необходимо произвести восстановление. Например:
```
sudo make DUMP="userside_2019-05-08_09-23-19.dump" dbrestore
```

### Фоновые процессы и RabbitMQ
Для мониторинга состояния брокера RabbitMQ используется модуль **RabbitMQ management** WEB-интерфейс которого доступен по адресу http://your.userside.net:15672 (домен замените на тот что используется для ERP USERSIDE, имя пользователя и пароль такие, как вы задали в **.env** файле для переменных `RABBITMQ_DEFAULT_USER` и `RABBITMQ_DEFAULT_PASS`).

Если фоновые задания выполняются с большой задержкой, вам следует обратить внимание на загруженность очередей (на вкладке Queues) и если очереди постоянно или довольно часто и подолну содержат относительно большое количество сообщений, вы можете изменить количество запускаемых экземпляров фоновых процессов для каждой из них.

Очередь **userside** отвечает за сообщения, передаваемые обработчику ядра. Количество экземпляров этого обработчика можно задать в переменной окружения `CORE_WORKER_NUM` в файле **.env** бандла (не userside).

Очередь **network_poller** отвечает за сообщения, передаваемые микросервису поллера, который выполняет операции по взаимодействию с оборудованием. Количество экземпляров этого микросервиса можно задать в переменной окружения `POLLER_NUM` в файле **.env** бандла (не userside).

Если значения для этих переменных изменялись, необходимо перезагрузить бандл:
```
bundle-restart
```
Если используется **Makefile**, то:
```
sudo make restart
```

## Тонкая настройка
Для достижения максимальной производительности рекомендуется произвести тонкую настройку окружения. Принципы описаны [на нашей специальной wiki-странице](https://wiki.userside.eu/Tuning).

### PHP и FPM
Изменять настройки для служб Docker-бандла можно при помощи подключаемых через тома (volumes) файлов. В файле **compose.yaml** для служб **php**, **fpm** имеются закомментированные тома для файлов, в которых можно разместить дополнительные опции для тонкой настройки.

Скопируйте файлы php.ini-example и www.conf-example в подкаталоге config в файлы php.ini и www.conf соответственно и отредактируйте их. Затем ракомментируйте соответствующие тома (volumes) в службах php и fpm файла compose.yaml и перезапустите бандл:
```
bundle-restart
```
Если используется **Makefile**, то:
```
sudo make restart
```

### PostgreSQL
Файлы конфигурации PostgreSQL находятся в подкаталоге data/db и могут быть отредактированы прямо там. После редактирования нужно так же перезапустить бандл:
```
bundle-restart
```
Если используется **Makefile**, то:
```
sudo make restart
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
Теперь отредактируйте файл `.env` в каждом из каталогов бандлов. Вам необходимо обязательно указать абсолютный путь к бандлу (переменная `USERSIDE_BASE_DIR`) и имя проекта (переменная `PROJECT_NAME`), например, **userside-production** и **userside-testing**.

При необходимости измените остальные переменные. Например, для тестовой копии USERSIDE вовсе не обязательно запускать 10 копий core_worker процессов и также не обязательно запускать 5 копий микросервисов поллеров. Для тестовой копии будет достаточно по одной копии, так как нагрузка на тестовую копию предполагается минимальной.

##### Файл compose.yaml
Теперь необходимо внести измение в файл настройки бандла `compose.yaml`. Здесь необходимо изменить только настройки, касающиеся сети. Бандлы должны использовать разные подсети, а размер подсети должен быть достаточным, чтобы уместить все контейнеры бандла с некоторым запасом.

По умолчанию в примере этого файла используется подсеть 172.31.254.0/25. Если эта подсеть подходит Вам (не пересекается с имеющимися подсетями на предприятии), то оставьте ее такой в одном из бандлов, а во втором измените на, например, 172.31.254.128/25. Для этого в блоке настроек **networks** необходимо изменить значение для параметра **subnet**.

Первый адрес узла из каждой подсети будет отдан интерфейсу хоста, а остальные случайным образом назначены контейнерам бандла. В данном примере IP-адреса 172.31.254.1 и 172.31.254.129 будут назначены интерфейсам bridgeXXX на хосте. Эти адреса удобно использовать для трансляции портов контейнеров.

Просмотрите внимательно параметр **ports** всех служб (services) в compose.yaml. Он содержит список портов, которые необходимо транслировать для каждого из сервисов. Например, запись `"172.31.254.1:8080:80"` для службы **nginx** означает, что порт 8080 интерфейса с адресом 172.31.254.1 на хосте должен транслироваться на порт 80 внутри контейнера с nginx. Это позволяет получить сетевой доступ внутрь бандла к контейнеру, обращаясь к IP адресу хоста.

Измените адреса так, чтобы ими были адреса первых узлов в соответствующей подсети. Для описываемого примера это 127.31.254.1 для первого бандла и 172.31.254.129 для второго бандла.

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
        proxy_send_timeout 240;
        proxy_read_timeout 240;
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
        proxy_send_timeout 240;
        proxy_read_timeout 240;
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
