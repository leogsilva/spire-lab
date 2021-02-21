FROM maven:3.5.3-jdk-8-alpine as KAFKA_API
RUN apk update && apk upgrade
WORKDIR /build
COPY spring-kafka/samples/sample-01/pom.xml .
RUN mvn dependency:go-offline
COPY spring-kafka/samples/sample-01/src/ /build/src
RUN mvn package -DskipTests=true
RUN mvn clean install 
#ARG JAR_FILE=target/*.jar
RUN cp target/*.jar apikafka.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "apikafka.jar"]