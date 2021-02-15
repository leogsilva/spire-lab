#!/bin/bash

IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f bare-kafka/docker/Dockerfile bare-kafka/docker
docker push k3d-myregistry.localhost:5000/${IMAGE}