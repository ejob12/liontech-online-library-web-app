# Build stage with Maven 3.8.7 and JDK 21
FROM maven:3.8.7-eclipse-temurin AS build
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

# Build the application, skipping tests
RUN mvn clean package -DskipTests

# Runtime stage with JRE 21
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy the built WAR and webapp-runner
COPY --from=build /app/target/onlinebookstore.war app.war
COPY --from=build /app/target/dependency/webapp-runner.jar webapp-runner.jar

# Expose application port (changed to 9090)
EXPOSE 9090

# Run the WAR using webapp-runner
ENTRYPOINT ["java","-jar","webapp-runner.jar","--port","9090","app.war"]

