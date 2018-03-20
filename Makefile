install: up us-install
	/bin/sh create-configs.sh
	echo "Install complete."

up:
	docker-compose -p userside up -d

stop:
	docker-compose -p userside stop

down:
	docker-compose -p userside down

uninstall: down
	docker volume prune -f
	rm /etc/cron.d/userside /etc/logrotate.d/userside
	rm -rf /var/log/userside/nginx

psql:
	docker-compose -p userside exec postgres psql -U userside

us-install:
	docker-compose -p userside exec fpm /app/install.sh

us-backup:
	docker-compose -p userside exec postgres ./backup.sh
	docker-compose -p userside exec fpm /app/backup.sh

us-cron:
	docker-compose -p userside exec fpm php userside cron
