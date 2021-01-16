# Step : Test and package
FROM maven:3.5.3-jdk-8-alpine as target
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /build/src/
RUN mvn package -DskipTests=true

# Step : Package image
#FROM maven:3.5.3-jdk-8-alpine
#EXPOSE 4567
#CMD exec java $JAVA_OPTS -jar /app/my-app.jar
#COPY --from=target /build/target/* /app/target/