FROM prom/snmp-exporter:v0.20.0
LABEL maintainer="taku.kimura@hpe.com"

ARG YAML_PATH

COPY $YAML_PATH /etc/snmp_exporter/snmp.yml