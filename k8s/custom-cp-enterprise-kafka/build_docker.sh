#!/bin/bash

IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f custom-cp-enterprise-kafka/Dockerfile custom-cp-enterprise-kafka
docker push k3d-myregistry.localhost:5000/${IMAGE}