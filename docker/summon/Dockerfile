# STAGE:
# Fetch summon
FROM ruby:2.5 as summon
#---install summon and summon-conjur---#
RUN curl -sSL https://raw.githubusercontent.com/cyberark/summon/main/install.sh \
      | env TMPDIR=$(mktemp -d) bash && \
    curl -sSL https://raw.githubusercontent.com/cyberark/summon-conjur/main/install.sh \
      | env TMPDIR=$(mktemp -d) bash

# STAGE:
# The 'maven' base is used to package the application
FROM maven:3.8.1-openjdk-17-slim as maven
WORKDIR /build
COPY ../../pom.xml .
# fetch all dependencies
RUN --mount=type=cache,target=$HOME/.m2 mvn dependency:go-offline -B

# copy other files
COPY ../../src src
RUN --mount=type=cache,target=$HOME/.m2 mvn -f /build/pom.xml clean package -DskipTests

# STAGE:
# This base is used for the final image
# It extracts the packaged application from the previous stage
# and builds the final image
FROM openjdk:11-jre-slim
COPY --from=summon /usr/local/lib/summon /usr/local/lib/summon
COPY --from=summon /usr/local/bin/summon /usr/local/bin/summon
COPY --from=maven /build/target/conjur-k8s-demo-1.0.jar /app/target/conjur-k8s-demo-1.0.jar
#---copy secrets.yml into image---#
COPY docker/summon/secrets.yml /etc/secrets.yml

EXPOSE 8080

#---override entrypoint to wrap command with summon---#
ENTRYPOINT ["summon", "--provider", "summon-conjur" ,"-f", "/etc/secrets.yml", "java", "-jar", "/app/target/conjur-k8s-demo-1.0.jar" ]