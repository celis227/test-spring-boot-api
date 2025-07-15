FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

COPY target/springboot-restful-webservices-0.0.1-SNAPSHOT.jar /app/springboot-restful-webservices.jar

EXPOSE 8080

CMD ["java", "-jar", "springboot-restful-webservices.jar"]