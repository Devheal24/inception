# COLOR
GREEN	:= \033[1;38;5;46m
RESET	:= \033[0m

COMPOSE_DIR	:= srcs
COMPOSE		:= docker compose --project-directory $(COMPOSE_DIR) -f $(COMPOSE_DIR)/docker-compose.yml

all: up

build:
	@$(COMPOSE) build

up:
	@$(COMPOSE) up -d --build
	@printf "${GREEN}==== inception: containers up ====${RESET}\n"

down:
	@$(COMPOSE) down
	@printf "${GREEN}==== inception: containers stopped and removed ====${RESET}\n"

stop:
	@$(COMPOSE) stop

start:
	@$(COMPOSE) start

restart:
	@$(COMPOSE) restart

logs:
	@$(COMPOSE) logs -f

ps:
	@$(COMPOSE) ps

clean: down

fclean:
	@$(COMPOSE) down -v --rmi all
	@printf "${GREEN}==== inception: containers, volumes and images removed ====${RESET}\n"

re: fclean all

.PHONY: all build up down stop start restart logs ps clean fclean re
