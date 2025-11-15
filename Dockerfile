FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /inventory
COPY gradlew .
COPY gradle gradle

COPY build.gradle settings.gradle ./
COPY src ./src

RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon

FROM eclipse-temurin:21-jre-alpine AS runtime

WORKDIR /app

COPY --from=build /inventory/build/libs/*.jar app.jar

EXPOSE 8092

ENTRYPOINT ["java", "-jar", "app.jar"]