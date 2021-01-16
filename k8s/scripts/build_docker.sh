#!/bin/bash

docker build -t k3d-myregistry.localhost:5000/java-kafka-ssl-factory:local -f java-kafka-ssl-factory/Dockerfile java-kafka-ssl-factory
docker push k3d-myregistry.localhost:5000/java-kafka-ssl-factory:local