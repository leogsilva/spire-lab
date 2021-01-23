#!/bin/bash

PROJECT_DIR="project"
IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
pushd kafka-consumer-app/go-kafka/${PROJECT_DIR}
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f ./deployments/Dockerfile .
popd
docker push k3d-myregistry.localhost:5000/${IMAGE}