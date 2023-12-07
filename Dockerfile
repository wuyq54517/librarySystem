FROM openjdk:17
EXPOSE 8080
COPY big-event-1.0-SNAPSHOT.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
