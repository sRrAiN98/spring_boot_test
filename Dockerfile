FROM openjdk:17.0.2-slim

WORKDIR /app
ADD target/demo-0.0.1-SNAPSHOT.jar /app/app.jar
ENTRYPOINT ["java","-jar","app.jar"]
