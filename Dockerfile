# Stage 1: Build the application
# Using a common and reliable Maven base image
FROM maven:3.8.5-openjdk-17-slim AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Create the final, lightweight image
# Using a widely available and stable JRE base image
FROM eclipse-temurin:17-jre-focal
WORKDIR /app
COPY --from=builder /app/target/SmartContactManager-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]