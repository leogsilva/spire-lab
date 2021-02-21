FROM maven:3.5.3-jdk-8-alpine as KAFKA_API
RUN apk update --no-cache
WORKDIR /build
COPY kafkaapp/pom.xml .
COPY kafkaapp/src/ /build/src
COPY kafkaapp/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]