# Use a Java 17 base image
FROM eclipse-temurin:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper and pom.xml first (for better Docker layer caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Copy the source code
COPY src src

# Package the application, skipping tests
RUN ./mvnw package -DskipTests

# Expose the port that Render will inject
EXPOSE 10000

# Run the JAR file. The PORT is provided by Render at runtime.
ENTRYPOINT ["java", "-jar", "/app/target/ride-0.0.1-SNAPSHOT.jar"]