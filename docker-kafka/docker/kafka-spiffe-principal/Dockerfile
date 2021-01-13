FROM maven:3-jdk-8-alpine
WORKDIR /usr/src/app
RUN apk update && apk add git -y && git clone https://github.com/traiana/kafka-spiffe-principal
CMD cd kafka-spiffe-principal && mvn clean install 
