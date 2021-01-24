#!/bin/bash

kubectl exec kafka-cp-kafka-0 -- \
    kafka-topics --create --bootstrap-server localhost:9092 --topic simple-consumer