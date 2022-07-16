FROM maven:3.8.1-openjdk-17-slim as maven

WORKDIR /build
COPY ../../pom.xml .
# fetch all dependencies
RUN --mount=type=cache,target=$HOME/.m2 mvn -Ppostgresql dependency:go-offline -B

# copy other files
COPY ../../src src
RUN --mount=type=cache,target=$HOME/.m2 mvn -Ppostgresql -f /build/pom.xml clean package -DskipTests

FROM openjdk:11-jre-slim
COPY --from=maven /build/target/conjur-k8s-demo-1.0.jar /app/target/conjur-k8s-demo-1.0.jar

EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/app/target/conjur-k8s-demo-1.0.jar" ]