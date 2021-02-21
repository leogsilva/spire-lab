#!/bin/bash

IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f java-kafka-ssl-factory/Dockerfile java-kafka-ssl-factory
docker push k3d-myregistry.localhost:5000/${IMAGE}

#docker build  -f  demo/back-end/Dockerfile java-kafka-api-image 
#docker push k3d-myregistry.localhost:8080/java-kafka-api-image