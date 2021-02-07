# Step : Test and package
FROM maven:3.5.3-jdk-8-alpine as SSL_TARGET
WORKDIR /build
COPY java-kafka-ssl-factory/pom.xml .
RUN mvn dependency:go-offline
COPY java-kafka-ssl-factory/src/ /build/src/
RUN mvn package -DskipTests=true


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
COPY --from=SSL_TARGET /build/target/java-kafka-ssl-factory-0.0.1.jar /usr/share/java/kafka/
COPY broker_keystore_creds /etc/kafka/secrets/broker_keystore_creds
COPY broker_sslkey_creds /etc/kafka/secrets/broker_sslkey_creds
COPY broker_truststore_creds /etc/kafka/secrets/broker_truststore_creds
COPY kafka.broker.keystore.jks /etc/kafka/secrets/kafka.broker.keystore.jks
COPY kafka.broker.truststore.jks /etc/kafka/secrets/kafka.broker.truststore.jks
