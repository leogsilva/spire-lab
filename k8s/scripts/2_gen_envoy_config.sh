#!/bin/bash

pushd ${PROJECT_HOME}/kafka-consumer-app/envoy-config-generator
j2 envoy.yaml.j2 vars.yaml > ${PROJECT_HOME}/kafka-consumer-app/config/envoy.yaml
popd