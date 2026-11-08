COMPOSE = docker compose -f srcs/docker_compose.yml

inception: prepare
	$(COMPOSE) up --build

prepare:
	mkdir -p /home/sael-kha/data/mariadb
	mkdir -p /home/sael-kha/data/wordpress

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down -v --rmi all --remove-orphans
	docker system prune -af
	rm -rf /home/sael-kha/data

re: fclean inception

.PHONY: inception prepare up stop start clean fclean re