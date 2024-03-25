# Commands can be run through `make <command>`
# .PHONY indicates that the target is not a file
# @ at the start of the command silence its output
# Comments after ## are used for help
# When run with no target shows help
# Syntax uses the following convention:
#  - https://www.thapaliya.com/en/writings/well-documented-makefiles/

.DEFAULT_GOAL := help
.ONESHELL:

.PHONY: help local production build up down clean

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<environment> <target>\033[0m\n\nenvironments:\n  - local\n  - production\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


local:
	$(MAKE) env=local $(filter-out $@,$(MAKECMDGOALS))

production:
	$(MAKE) env=production $(filter-out $@,$(MAKECMDGOALS))

##@ Containers
build:  ## build the stack
ifdef env
	@docker compose -f $(env).yml build
endif

up:  ## start containers
ifdef env
	@docker compose -f $(env).yml up
endif

down:  ## stop and remove containers
ifdef env
	@docker compose -f $(env).yml down
endif

clean: ## remove all docker images
	@if [ -n "$$(docker images -f 'dangling=true' -q)" ]; then \
		docker rmi $$(docker images -f 'dangling=true' -q); \
	else \
		echo "No dangling images to remove."; \
	fi

##@ Django
createsuperuser: ## create super user
ifdef env
	@docker compose  -f $(env).yml run --rm django python manage.py createsuperuser
endif

migrate:  ## make migrations
ifdef env
	@docker compose -f $(env).yml run --rm django python manage.py migrate
endif


%:
	@:
