FROM openjdk:8-alpine

WORKDIR /app
ADD build/libs/demo-0.0.1-SNAPSHOT.jar /app/app.jar
ENTRYPOINT ["java","-jar","app.jar"]