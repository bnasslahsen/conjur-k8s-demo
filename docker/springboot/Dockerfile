FROM openjdk:11-jre-slim
COPY target/conjur-k8s-demo-1.0.jar /app/target/conjur-k8s-demo-1.0.jar

EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/app/target/conjur-k8s-demo-1.0.jar" ]