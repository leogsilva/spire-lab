#!/bin/bash

set -x -o errexit

docker pull dinutac/jinja2docker:latest
pushd ${PROJECT_HOME}/kafka-consumer-app
docker run --rm -v ${PWD}/envoy-config-generator:/templates \
-v ${PWD}/envoy-config-generator:/variables \
-v ${PWD}/config/:/tmp \
dinutac/jinja2docker:latest /templates/envoy.yaml.j2 /variables/vars.yaml --format=yaml
popd



