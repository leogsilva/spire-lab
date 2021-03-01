#!/bin/bash

pushd ${PROJECT_HOME}/tmpdir
kubectl create secret generic ca-truststore --from-file=./ca.crt -n kafka -o yaml --dry-run=client > ca-truststore.yaml

kubectl apply -n kafka -f ca-truststore.yaml
popd