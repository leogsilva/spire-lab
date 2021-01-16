#!/bin/bash

IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f java-kafka-ssl-factory/Dockerfile java-kafka-ssl-factory
docker push k3d-myregistry.localhost:5000/${IMAGE}