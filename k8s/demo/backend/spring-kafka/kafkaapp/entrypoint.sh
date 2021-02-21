#!/bin/sh

mvn package -DskipTests=true &&\
    java -Djava.security.egd=file:/dev/./urandom -jar /build/target/kafka-sample-01-2.6.5.jar