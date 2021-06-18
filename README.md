# ERP USERSIDE Docker Bundle v3.16.1

## О проекте
Данный проект представляет собой **набор образцов** конфигурационных файлов и скриптов для запуска Docker-бандла системы ERP USERSIDE. Все необходимые для работы ERP USERSIDE образы уже собраны со всеми необходимыми зависимостями и настройками и размещены в [Docker HUB](https://hub.docker.com/repository/docker/erpuserside/userside). Вы можете на основе данных образцов собрать свой бандл, используя Docker-composer либо испльзуя другие, удобные вам, инструменты оркестрации. Вы также можете воспользоваться образцами как есть и получить работающую систему ERP USERSIDE без каких либо дополнительных действий. Мы полностью полагаемся на ваше понимание работы контейнеризации в Linux, работы Docker, docker-compose, swarm и других систем, которые вы собираетесь использовать.

Данные образцы Docker-окружения распространяются «как есть» без каких либо гарантий. Мы также не оказываем техническую поддержку по вопросам установки, настройки и обслуживания Docker и связанных с ним инструментов. Если вы не знакомы с Docker, то вам следует воспользоваться классическим примером установки ERP USERSIDE на Linux-сервер.

## Важное замечание для предрелизной версии ERP USERSIDE
Официальный стабильный релиз ERP USERSIDE 3.16 еще выпущен. Данная инструкция адаптирована для использования DEV/BETA-версий ERP USERSIDE. После выхода стабильного релиза ERP USERSIDE 3.16 инструкция будет изменена, а изменения влиты в **master**.

## Установка
1. Выделите доменное имя для ERP USERSIDE и создайте необходимые записи на DNS-сервере либо в файле /etc/hosts на текущем сервере, проверьте, что имя разрешается в IP-адрес корректно.
2. Загрузите и установите Docker и docker-compose.
3. Создайте каталог, в котором будет размещаться бандл, и перейдите в него. Например:
```
sudo mkdir -p /docker && cd $_
```
4. Склонируйте этот репозиторий в подкаталог userside и перейдитие в него:
```
sudo git clone -–depth 1 --branch v3.16 https://github.com/userside/userside-docker.git userside && cd userside
```
5. Выполните команду инициализации конфигов бандла — она создаст копии образцов с рабочими именами файлов. Теперь у вас есть файлы **.env**, **docker-compose.yml**, **Makefile**:
```
sudo ./init.sh
```
6. Отредактируйте файл **.env** при помощи команды `sudo nano .env` — укажите в нем все значения переменных (путь для развёртывания файлов бандла, имя проекта, часовой пояс и локаль, логины и пароли для служб и т.д.)
7. Необязательно, только при необходимости, внесите изменения в файлы **docker-compose.yml** и **Makefile**. Например, вы можете подключить альтернативные файлы **php.ini** и **www.conf** из каталога **configs** раскомментировав соответствующие строки в файле **docker-compose.yml**, а затем скопировав файлы из применов (в каталоге config) и отредактировав их в соответствии с необходимостью. Или же изменить адрес выделяемой для бандла IP-подсети.
8. Запустиите установку бандла и ERP USERSIDE следующей командой и следуйте инструкциям:
```
sudo make install
```
9. После установки необходимо перезапустить бандл, чтобы запустить корректно все фоновые процессы:
```
sudo make restart
```
10. Если вы планируете включить экспериментальную функцию ERP USERSIDE для работы с websocket, то дополнительно нужно создать WebSTOMP-пользователя в RabbitMQ. Это можно сделать двумя способами на выбор:
    1. Либо выполнив набор команд:
    ```
    sudo docker-compose -p userside exec rabbitmq \
        rabbitmqctl add_user "userside-stomp" "password"
    sudo docker-compose -p userside exec rabbitmq \
        rabbitmqctl set_permissions -p "/" "userside-stomp" "^userside-stomp:id-.*" "" "^userside-stomp:id-.*"
    ```
    2. Либо через панель управления RabbitMQ. Для этого откройте в браузере http://your.userside.net:15672 (домен замените на тот что используется для ERP USERSIDE, имя пользователя и пароль такие, как вы задали в .env файле для переменных RABBITMQ_DEFAULT_USER и RABBITMQ_DEFAULT_PASS), перейдите на вкладку **Admin**, внизу в разделе **Add a user** в качестве имени пользователя укажите имя пользователя, например, userside-stomp и задайте пароль. Поле с тэгами оставьте пустым. Затем нажмите **Add user**. Теперь выше в разделе **All users** кликните по только что созданному пользователю, чтобы открыть его параметры. В разделе **Permissions** для **Configure regexp** и для **Read regexp** задайте значение `^userside-stomp:id-.*`, а для **Write regexp** удалите значение, оставив поле пустым. Нажмите кнопку **Set permission**.

## Обновление
### В пределах версии Docker-бандла 3.16
Для обновления ERP USERSIDE в пределах бандла версии 3.16 никаких дополнительных действий не требуется. Запустите команду и следуйте инструкциям:
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
sudo make backup && sudo make stop
```
2. Переключитесь на ветку **v3.16**:
```
sudo git checkout v3.16
sudo git pull
```
3. Переименуйте файл docker-compose.yml чтобы не затереть его содержимое в процессе обновления:
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
6. Из файла **docker-compose_3-13.yml** перенесите все значения переменных в файл **.env**. Укажите в значении переменной `USERSIDE_BASE_DIR` полный путь к каталогу, в котором развернут бандл (текущему каталогу). В данном примере это `/docker/userside`.
7. Начиная с версии бандла 3.16 пароль для Redis обязателен. Если у вас раньше не было пароля, задайте его в переменной `REDIS_PASSWORD` файла **.env**, а затем добавьте в файл **./data/userside/.env** переменную `US_REDIS_PASSWORD` с точно таким же паролем.
8. В файле `.env` имеются переменные, отвечающие за количество контейнеров, запускаемых для сервисов-обработчиков: `CORE_WORKER_NUM` и `POLLER_NUM`. По умолчанию они установлены в 10 и 5 соответственно. Если вам нужно больше обработчиков — измените эти цифры здесь. Для начала рекомендуем оставить их по умолчанию.
9. **Только для не стабильных релизов.** Так как стабильный релиз ERP USERSIDE 3.16 еще не вышел, вы можете установить только dev (beta, rc) версии. Для этого вам нужно изменить конфигурация инсталлятора для понижения уровня стабильности устанавливаемых версий:
```
sudo make STABILITY_LEVEL="dev" us-change-stability
```
10. Запустите инсталляцию. При обновлении с версии бандла 3.13 на 3.16 нужно выполнить именно эту команду, а не **update**. В дальнейшем при обновлении в пределах версии бандла 3.16 нужно будет использовать `sudo make update`.
```
sudo make install
```
11. Проследите, чтобы обновление до ERP USERSIDE 3.16dev прошло корректно.
12. Удалите файл **docker-compose_3-13.yml** — он больше не нужен. Если вы сохраняли файл Makefile (п.4), перенесите из него все ваши изменения в новый Makefile и удалите старый.
```
sudo rm docker-compose_3-13.yml
```


## Эксплуатация
### Резервное копирование
Сценарием автоматического развёртывания устанавливаются и настраиваются все необходимые компоненты системы, в том числе периодическое резервное копирование (задание помещается в системный cron).

### Фоновые процессы и RabbitMQ
Для мониторинга состояния брокера RabbitMQ используется модуль **RabbitMQ management** WEB-интерфейс которого доступен по адресу http://your.userside.net:15672 (домен замените на тот что используется для ERP USERSIDE, имя пользователя и пароль такие, как вы задали в **.env** файле для переменных `RABBITMQ_DEFAULT_USER` и `RABBITMQ_DEFAULT_PASS`).

Если фоновые задания выполняются с большой задержкой, вам следует обратить внимание на загруженность очередей (на вкладке Queues) и если очереди постоянно или довольно часто и подолну содержат относительно большое количество сообщений, вы можете изменить количество запускаемых экземпляров фоновых процессов для каждой из них.

Очередь **userside** отвечает за сообщения, передаваемые обработчику ядра. Количество экземпляров этого обработчика можно задать в переменной окружения `CORE_WORKER_NUM` в файле **.env** бандла (не userside).

Очередь **network_poller** отвечает за сообщения, передаваемые микросервису поллера, который выполняет операции по взаимодействию с оборудованием. Количество экземпляров этого микросервиса можно задать в переменной окружения `POLLER_NUM` в файле **.env** бандла (не userside).

Если значения для этих переменных изменялись, необходимо перезагрузить бандл
```
sudo make restart
```

---

Ознакомьтесь пожалуйста [с этой статьей WIKI](https://wiki.userside.eu/Docker_%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5).

---