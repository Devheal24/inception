# COLOR
GREEN	:= \033[1;38;5;46m
CYAN	:= \033[1;38;5;51m
RED		:= \033[1;38;5;196m
RESET	:= \033[0m

COMPOSE_DIR	:= srcs
COMPOSE		:= docker compose --project-directory $(COMPOSE_DIR) -f $(COMPOSE_DIR)/docker-compose.yml
DATA_DIR	:= $(HOME)/data

help:
	@echo "$(GREEN)Usage:$(RESET) make [target]"
	@echo ""
	@echo "  $(CYAN)all$(RESET)        Build and start all containers in the background"
	@echo "  $(CYAN)clean$(RESET)      Stop and remove containers"
	@echo "  $(CYAN)fclean$(RESET)     Remove containers, volumes and images"
	@echo "  $(CYAN)re$(RESET)         Full rebuild (fclean + all)"
	@echo ""
	@echo "  $(CYAN)up$(RESET)         Alias for all"
	@echo "  $(CYAN)down$(RESET)       Alias for clean"
	@echo "  $(CYAN)build$(RESET)      Build all images without starting containers"
	@echo "  $(CYAN)start$(RESET)      Start previously stopped containers"
	@echo "  $(CYAN)stop$(RESET)       Stop containers without removing them"
	@echo "  $(CYAN)restart$(RESET)    Restart all containers"
	@echo ""
	@echo "  $(CYAN)help$(RESET)       Show this help"
	@echo "  $(CYAN)logs$(RESET)       Follow containers logs"
	@echo "  $(CYAN)ps$(RESET)         List containers status"
	@echo "  $(CYAN)purge-data$(RESET) $(RED)DESTROY mariadb/wordpress data (fclean first)$(RESET)\n"

all:
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress $(DATA_DIR)/backup
	@$(COMPOSE) up -d --build
	@printf "${GREEN}==== inception: containers up ====${RESET}\n"

build:
	@$(COMPOSE) build

up: all

down: clean

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

clean:
	@$(COMPOSE) down
	@printf "${GREEN}==== inception: containers stopped and removed ====${RESET}\n"

fclean:
	@$(COMPOSE) down -v --rmi all
	@printf "${GREEN}==== inception: containers, volumes and images removed ====${RESET}\n"

re: fclean all

purge-data: fclean
	@docker run --rm -v $(DATA_DIR)/mariadb:/target alpine sh -c "rm -rf /target/*"
	@docker run --rm -v $(DATA_DIR)/wordpress:/target alpine sh -c "rm -rf /target/*"
	@printf "${GREEN}==== inception: persisted mariadb/wordpress data wiped ====${RESET}\n"

.PHONY: help all build up down stop start restart logs ps clean fclean re purge-data
