export APP_NAME := $(notdir $(shell pwd))
DESC :=
PROJECT_URL := "https://github.com/gomatic/$(APP_NAME)"

.PHONY : buld ec2 run test
.PHONY : help
.DEFAULT_GOAL := help

PREFIX ?= usr/local

#

build: go/bin/counselor ## Build the consul-counselor container
	docker build --tag gomatic/consul-counselor .

go/bin/counselor:
	mkdir -p $(dir $@)
	cd $(dir $@) && git clone https://github.com/gomatic/counselor
	cd $(dir $@)/counselor && make linux GOOS=linux GOARCH=amd64 && mv counselor-linux-amd64 counselor

ec2: TAG ?= discovery
ec2: ## Run the container using EC2 tag-join. Use TAG= to assign a tag. default: TAG=discovery
	docker run --rm -it -e "-retry-join-ec2-tag-value=$(TAG)" consul-counselor

run: ## Run the container. Needs to be with AWS.
	docker run --rm -it consul-counselor

test: build ## Test the container
	docker run --rm -it -e "COUNSELOR_MOCK=true" consul-counselor counselor test

help: ## This help.
	@echo $(APP_NAME)
	@echo $(PROJECT_URL)
	@echo Targets:
	@awk 'BEGIN {FS = ":.*?## "} / [#][#] / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
