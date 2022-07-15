FROM maven:3.8.1-openjdk-17-slim as maven

VOLUME ["/Users/Badr.NassLahsen/.m2", "/root/.m2"]

WORKDIR /build
COPY ../../pom.xml .
# fetch all dependencies
RUN mvn dependency:go-offline -B

# copy other files
COPY ../../src src

RUN mvn -f /build/pom.xml clean package -DskipTests

FROM openjdk:11-jre-slim
COPY --from=maven /build/target/conjur-k8s-demo-1.0.jar /app/target/conjur-k8s-demo-1.0.jar

EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/app/target/conjur-k8s-demo-1.0.jar" ]