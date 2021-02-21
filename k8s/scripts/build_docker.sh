#!/bin/bash

IMAGE=$(echo $EXPECTED_REF | cut -d '/' -f2)
<<<<<<< HEAD
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f java-kafka-ssl-factory/Dockerfile java-kafka-ssl-factory
docker push k3d-myregistry.localhost:5000/${IMAGE}

#docker build  -f  demo/back-end/Dockerfile java-kafka-api-image 
#docker push k3d-myregistry.localhost:8080/java-kafka-api-image
=======
docker build -t k3d-myregistry.localhost:5000/${IMAGE} -f bare-kafka/docker/Dockerfile bare-kafka/docker
docker push k3d-myregistry.localhost:5000/${IMAGE}
>>>>>>> 7faef6bf58290acb87e740f53d94aad46a54c213
