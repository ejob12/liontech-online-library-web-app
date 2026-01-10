# Build stage with Maven 3.8.7 and JDK 21
FROM maven:3.8.7-eclipse-temurin-21 AS build
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the application, skipping tests
RUN mvn clean package -DskipTests

# Runtime stage with JRE 21
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
