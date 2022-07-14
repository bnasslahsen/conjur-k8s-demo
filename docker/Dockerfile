####
# This Dockerfile is used in order to build a container that runs the Spring Boot application
#
# Build the image with:
#
# docker build -t bnasslahsen/conjur-k8s-demo .
#
# Then run the container using:
#
# docker run -i --rm -p 8081:8081 bnasslahsen/conjur-k8s-demo
####
FROM maven:3.8.1-openjdk-17-slim as maven

WORKDIR /build
COPY ../pom.xml .
COPY ../src src

RUN --mount=type=cache,target=$HOME/.m2 mvn -f /build/pom.xml clean package -DskipTests

FROM openjdk:11-jre-slim
COPY --from=maven /build/target/conjur-k8s-demo-1.0.jar /app/target/conjur-k8s-demo-1.0.jar

EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/app/target/conjur-k8s-demo-1.0.jar" ]