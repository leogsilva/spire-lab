#!/bin/bash

set -o errexit

if ! command -v j2 &> /dev/null
then
    echo "j2 could not be found"
    exit
fi

pushd ${PROJECT_HOME}/kafka-consumer-app/envoy-config-generator
j2 envoy.yaml.j2 vars.yaml > ${PROJECT_HOME}/kafka-consumer-app/config/envoy.yaml
popd