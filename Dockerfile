# Use the official OpenJDK 17 base image
FROM openjdk:17-jdk-slim as build

# Install Maven
RUN apt-get update && apt-get install -y maven

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the project source code into the container
COPY src ./src

# Build the Spring Boot application using Maven
RUN mvn clean package -DskipTests

# Start a new stage to reduce image size
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the previous stage
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /app/hello1springboot.jar

# Expose the port on which the Spring Boot app will run
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "hello1springboot.jar"]
