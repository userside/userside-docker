install: up us-install
	/bin/bash create-configs.sh
	@echo "Install complete."

up:
	docker-compose -p userside up -d

stop:
	docker-compose -p userside stop

down:
	docker-compose -p userside down

pull:
	docker-compose -p userside pull

update: us-backup stop pull install

uninstall: down
	docker volume prune -f
	docker network prune -f
	rm /etc/cron.d/userside /etc/logrotate.d/userside
	rm -rf /var/log/userside/nginx

psql:
	docker-compose -p userside exec postgres psql -U userside

backup:
	docker-compose -p userside exec postgres /app/backup.sh
	docker-compose -p userside exec fpm /app/backup.sh

dbrestore:
	docker-compose -p userside exec postgres /app/restore.sh ${ARGS}

us-install:
	docker-compose -p userside exec fpm /app/install.sh

run-cron:
	docker-compose -p userside exec fpm php userside cron
