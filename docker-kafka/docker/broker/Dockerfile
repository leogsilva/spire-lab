FROM maven:3-jdk-8-alpine as BUILD
WORKDIR /usr/src/app
RUN apk update && apk add git -y && git clone https://github.com/traiana/kafka-spiffe-principal
RUN cd kafka-spiffe-principal && mvn clean install 

FROM confluentinc/cp-kafka:4.0.0-3
COPY --from=BUILD /usr/src/app/kafka-spiffe-principal/target/kafka-spiffe-principal-2.0.0.jar /usr/share/java/kafka/
COPY ./secrets /etc/kafka/secrets