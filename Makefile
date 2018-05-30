confirmation:
	@( read -p "This action will delete all data!!! Are you sure? [y/N]: " sure && case "$$sure" in [yY]) true;; *) false;; esac )

install: up us-install
	/bin/bash create-configs.sh
	@echo "Install complete."

up:
	docker-compose -p userside up -d

stop:
	docker-compose -p userside stop

down: confirmation
	docker-compose -p userside down

pull:
	docker-compose -p userside pull

update: backup stop pull install

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
	docker-compose -p userside exec postgres /app/restore.sh ${DUMP}

us-install:
	docker-compose -p userside exec fpm /app/install.sh

run-cron:
	docker-compose -p userside exec fpm php userside cron
