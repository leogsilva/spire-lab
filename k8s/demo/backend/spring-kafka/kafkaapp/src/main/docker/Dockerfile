FROM maven:3.5.3-jdk-8-alpine as KAFKA_API
RUN apk update --no-cache
WORKDIR /build
COPY kafkaapp/pom.xml .
RUN mvn dependency:go-offline
COPY kafkaapp/src/ /build/src
RUN mvn package -DskipTests=true
#ARG JAR_FILE=target/*.jar
RUN cp target/*.jar /apikafka.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/apikafka.jar"]