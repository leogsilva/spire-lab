#!/bin/bash

IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
echo "Building ${IMAGE} here ${PWD}"

pushd bare-kafka/docker/
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f Dockerfile .
popd
docker push k3d-myregistry.localhost:5000/${IMAGE}