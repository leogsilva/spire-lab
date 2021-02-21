#!/bin/sh

mvn package -DskipTests=true &&\
    java -Djava.security.egd=file:/dev/./urandom -jar /apikafka.jar