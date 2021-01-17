FROM maven:3.5.3-jdk-8-alpine as PROVIDER
WORKDIR /usr/src/app
RUN apk update && apk add curl -y && curl -LO https://github.com/spiffe/java-spiffe/releases/download/v0.6.3/java-spiffe-provider-0.6.3-all-linux-x86_64.jar

FROM maven:3.5.3-jdk-8-alpine as SPIFFE
WORKDIR /usr/src/app
RUN apk update && apk add git -y && git clone https://github.com/traiana/kafka-spiffe-principal
RUN cd kafka-spiffe-principal && mvn clean install 

FROM confluentinc/cp-enterprise-kafka:6.0.1
COPY --from=PROVIDER /usr/src/app/java-spiffe-provider-0.6.3-all-linux-x86_64.jar /usr/share/java/kafka/
COPY --from=SPIFFE /usr/src/app/kafka-spiffe-principal/target/kafka-spiffe-principal-2.0.0.jar /usr/share/java/kafka/
COPY java.security /usr/lib/jvm/zulu11/conf/security/
