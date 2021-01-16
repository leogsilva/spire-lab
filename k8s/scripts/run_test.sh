#!/bin/bash

POD_NAME=$(kubectl get pods --selector=app=client --output=jsonpath={.items..metadata.name})
kubectl exec -ti $POD_NAME mvn test 