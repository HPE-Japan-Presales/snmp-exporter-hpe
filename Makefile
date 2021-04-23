PROJECT=snmp-exporter-hpe
DOCKER_HUB_USER=fideltak
CURRENT_VERSION=$(shell git describe --tags --abbrev=0)
SIM_VERSIONS := upd11_30mib upd11_35mib upd11_40mib upd11_50mib
YAML_NAME = snmp.yml

define DOCKER_BUILD
   echo "## Build Docker Image $(DOCKER_HUB_USER)/$(PROJECT):$(1)_$(CURRENT_VERSION) ##"
   docker build -t $(DOCKER_HUB_USER)/$(PROJECT):$(1)_$(CURRENT_VERSION) --build-arg YAML_PATH=$(1)/$(YAML_NAME) .

endef

define DOCKER_PUSH
   echo "## Push Docker Image $(DOCKER_HUB_USER)/$(PROJECT):$(1)_$(CURRENT_VERSION) ##"
   docker push $(DOCKER_HUB_USER)/$(PROJECT):$(1)_$(CURRENT_VERSION)

endef

all: build push

build:
	@$(foreach version,$(SIM_VERSIONS),$(call DOCKER_BUILD,$(version)))

push:
	@$(foreach version,$(SIM_VERSIONS),$(call DOCKER_PUSH,$(version)))