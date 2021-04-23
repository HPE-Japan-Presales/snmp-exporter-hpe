PROJECT=snmp-exporter-hpe
#CURRENT_VERSION=$(shell git describe --tags --abbrev=0)
CURRENT_VERSION=v0.0.1
SIM_VERSIONS := upd11_30mib upd11_35mib upd11_40mib upd11_50mib
YAML_NAME = snmp.yml

define DOCKER_BUILD
   echo "## Build Docker Image $(PROJECT):$(1)_$(CURRENT_VERSION) ##"
   docker build -t $(PROJECT):$(1)_$(CURRENT_VERSION) --build-arg YAML_PATH=$(1)/$(YAML_NAME) .

endef

define DOCKER_PUSH
   echo "## Push Docker Image $(PROJECT):$(1)_$(CURRENT_VERSION) ##"
   docker push $(PROJECT):$(1)_$(CURRENT_VERSION)

endef

all: build push

build:
	@$(foreach version,$(SIM_VERSIONS),$(call DOCKER_BUILD,$(version)))

push:
	@$(foreach version,$(SIM_VERSIONS),$(call DOCKER_PUSH,$(version)))