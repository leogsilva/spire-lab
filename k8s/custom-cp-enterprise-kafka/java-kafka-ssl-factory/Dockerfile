# Step : Test and package
FROM maven:3.5.3-jdk-8-alpine
WORKDIR /build
COPY pom.xml .
RUN mvn     dependency:go-offline

COPY src/ /build/src/
RUN mvn compile
RUN mvn test -Dmaven.test.failure.ignore=true
#sCMD mvn test

# Step : Package image
#FROM maven:3.5.3-jdk-8-alpine
#EXPOSE 4567
#WORKDIR /app
#COPY --from=target /root/.m2/* /root/.m2/
#COPY --from=target /build/pom.xml /app/
#COPY --from=target /build/target/* /app/target/
#COPY --from=target /build/src/* /app/src/
#CMD exec mvn $JAVA_OPTS -jar /app/my-app.jar
