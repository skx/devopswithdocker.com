
# https://hub.docker.com/_/openjdk
FROM openjdk:8

# Setup working directory
WORKDIR /app

# Install git to clone.
RUN apt-get update && apt-get install git-core --yes

# Clone
RUN cd /app && git clone https://github.com/docker-hy/spring-example-project.git

# Expose the port
EXPOSE 8080

# Build
RUN cd /app/spring-example-project && ./mvnw package

# Launch
ENTRYPOINT ["java", "-jar"]
CMD ["/app/spring-example-project/target/docker-example-1.1.3.jar"]
