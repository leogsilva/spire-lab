#!/bin/bash
EXPECTED_REF=$1
pushd ${PROJECT_HOME}/demo/backend/spring-kafka
IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f  kafkaapp/src/main/docker/Dockerfile .
docker push k3d-myregistry.localhost:5000/${IMAGE}
popd