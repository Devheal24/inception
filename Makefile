# COLOR
GREEN	:= \033[1;38;5;46m
CYAN	:= \033[1;38;5;51m
RESET	:= \033[0m

COMPOSE_DIR	:= srcs
COMPOSE		:= docker compose --project-directory $(COMPOSE_DIR) -f $(COMPOSE_DIR)/docker-compose.yml

help:
	@echo "$(GREEN)Usage:$(RESET) make [target]"
	@echo ""
	@echo "  $(CYAN)help$(RESET)      Show this help"
	@echo "  $(CYAN)all$(RESET)       Build and start all containers in the background"
	@echo "  $(CYAN)build$(RESET)     Build all images without starting containers"
	@echo "  $(CYAN)up$(RESET)        Alias for all"
	@echo "  $(CYAN)down$(RESET)      Stop and remove containers"
	@echo "  $(CYAN)stop$(RESET)      Stop containers without removing them"
	@echo "  $(CYAN)start$(RESET)     Start previously stopped containers"
	@echo "  $(CYAN)restart$(RESET)   Restart all containers"
	@echo "  $(CYAN)logs$(RESET)      Follow containers logs"
	@echo "  $(CYAN)ps$(RESET)        List containers status"
	@echo "  $(CYAN)clean$(RESET)     Alias for down"
	@echo "  $(CYAN)fclean$(RESET)    Remove containers, volumes and images"
	@echo "  $(CYAN)re$(RESET)        Full rebuild (fclean + all)"

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

.PHONY: help all build up down stop start restart logs ps clean fclean re
