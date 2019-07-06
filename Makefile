OS_VERSION := $(shell uname -a)
ifneq (,$(findstring Microsoft,$(OS_VERSION)))
$(info    detected WSL)
export DOCKER_COMPOSE=docker-compose
export DOCKER=docker
else ifeq ($(OS), Windows_NT)
$(info    detected Powershell/CMD)
export DOCKER_COMPOSE=docker-compose.exe
export DOCKER=docker.exe
else ifneq (,$(findstring Darwin,$(OS_VERSION)))
$(info    detected OSX)
export DOCKER_COMPOSE=docker-compose
export DOCKER=docker
else
$(info    detected native linux)
export DOCKER_COMPOSE=docker-compose
export DOCKER=docker
endif

export VCS_URL:=$(shell git config --get remote.origin.url)
export VCS_REF:=$(shell git rev-parse --short HEAD)
export VCS_STATUS_CLIENT:=$(if $(shell git status -s),'modified/untracked','clean')
export BUILD_DATE:=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

ifndef DOCKER_REGISTRY
export DOCKER_REGISTRY=itisfoundation
endif


.PHONY: help
help: ## This nice help (thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


.PHONY: build
build: pull update_compose_labels update_run_script ## Builds all service images.
	@${DOCKER_COMPOSE} -f docker-compose.yml build --parallel
	@echo Built image ${DOCKER_REGISTRY}/simcore/services/comp/osparc-opencor:latest

.PHONY: up down
up: .env down ## starts services.
	@mkdir -p tmp/output
	@mkdir -p tmp/log
	@${DOCKER_COMPOSE} -f docker-compose.yml up

down:  ## stops services.
	@${DOCKER_COMPOSE} -f docker-compose.yml down


.PHONY: unit-test integration-test test

unit-test: .venv # runs unit tests [w/ fail fast]
	@.venv/bin/pytest -x -v --junitxml=pytest_unittest.xml --log-level=warning tests/unit

integration-test: build .venv  ## runs integration tests [w/ fail fast] (needs built container)
	@.venv/bin/pytest -x -v --junitxml=pytest_integrationtest.xml --log-level=warning tests/integration

test: unit-test integration-test ## run all tests

.PHONY: push-release push
push-release: check-release check-pull push # pushes services to the registry if service not available in registry. push overwrites.

push: 
	# push both latest and :$$SERVICE_VERSION tags
	${DOCKER} login ${DOCKER_REGISTRY};\
	SERVICE_VERSION=$$(cat VERSION);\
	${DOCKER} tag \
		${DOCKER_REGISTRY}/simcore/services/comp/osparc-opencor:latest \
		${DOCKER_REGISTRY}/simcore/services/comp/osparc-opencor:$$SERVICE_VERSION;\
	${DOCKER} push \
		${DOCKER_REGISTRY}/simcore/services/comp/osparc-opencor:$$SERVICE_VERSION;\
	${DOCKER} push \
		${DOCKER_REGISTRY}/simcore/services/comp/osparc-opencor:latest;

pull: ## pull latest service version if available
	${DOCKER} pull \
		${DOCKER_REGISTRY}/simcore/services/comp/osparc-opencor:latest || true;


.env: .env-devel
	# first check if file exists, copies it
	@if [ ! -f $@ ]	; then \
		echo "##### $@ does not exist, copying $< ############"; \
		cp $< $@; \
	else \
		echo "#####  $< is newer than $@ ####"; \
		diff -uN $@ $<; \
		false; \
	fi

.PHONY: update_compose_labels update_run_script
update_compose_labels: .venv
	@.venv/bin/python tools/update_compose_labels.py \
		--compose docker-compose.yml \
		--input docker/labels

update_run_script: .venv
	@.venv/bin/python tools/run_creator.py \
		--folder docker/labels \
		--runscript service.cli/do_run

.PHONY: info
info: ## Displays some parameters of makefile environments
	@echo '+ VCS_* '
	@echo '  - ULR                : ${VCS_URL}'
	@echo '  - REF                : ${VCS_REF}'
	@echo '  - (STATUS)REF_CLIENT : (${VCS_STATUS_CLIENT})'
	@echo '+ BUILD_DATE           : ${BUILD_DATE}'
	@echo '+ OS_VERSION           : ${OS_VERSION}'
	@echo '+ DOCKER_REGISTRY      : ${DOCKER_REGISTRY}'


.venv: .env ## Creates a python virtual environment with dev tools (pip, pylint, ...)
	@python3 -m venv .venv
	@.venv/bin/pip3 install --upgrade pip wheel setuptools
	@.venv/bin/pip3 install -r requirements.txt
	@echo "To activate the venv, execute 'source .venv/bin/activate' or '.venv/bin/activate.bat' (WIN)"


.PHONY: clean
clean:  ## Cleans all unversioned files in project
	@git clean -dxf -e .vscode/


.PHONY: toc
toc: .venv ## Upates README.txt with a ToC of all services
	@.venv/bin/python ${CURDIR}/scripts/auto-doc/create-toc.py