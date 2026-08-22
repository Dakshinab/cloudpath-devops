# Start from a small image that already has Java 21 installed
FROM eclipse-temurin:21-jre-alpine

# Set the folder inside the container where our app will live
WORKDIR /app

# Copy our built jar file from your laptop into the container
COPY target/cloudpath-app-0.0.1-SNAPSHOT.jar app.jar

# Create a dedicated non-root user and switch to it
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Tell Docker this container listens on port 8080
EXPOSE 8080

# The actual command to run when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
