SHELL := /bin/sh
COMPOSE := docker compose

.PHONY: help up down logs ps psql reset migrate-up migrate-down seed

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

up: ## Start Postgres + PgBouncer + Adminer
	$(COMPOSE) up -d
	@echo "Postgres on localhost:$${POSTGRES_PORT:-5432} | Adminer http://localhost:8080"

down: ## Stop the stack (keeps data volume)
	$(COMPOSE) down

logs: ## Tail logs
	$(COMPOSE) logs -f postgres

ps: ## Show service status
	$(COMPOSE) ps

psql: ## Open a psql shell
	$(COMPOSE) exec postgres psql -U $${POSTGRES_USER:-livestock} -d $${POSTGRES_DB:-livestock}

reset: ## Stop the stack AND delete data (destructive)
	$(COMPOSE) down -v

migrate-up: ## Apply migrations from livestock-db
	cd ../livestock-db && dbmate up

migrate-down: ## Roll back the last migration
	cd ../livestock-db && dbmate rollback

seed: ## Load seed data from livestock-seed
	@for f in ../livestock-seed/seed/*.sql; do echo ">> $$f"; \
	  $(COMPOSE) exec -T postgres psql -U $${POSTGRES_USER:-livestock} -d $${POSTGRES_DB:-livestock} < $$f; done
