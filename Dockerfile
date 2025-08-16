# ---------- Build image ----------
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*
COPY pom.xml ./
RUN mvn -q -e -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -e clean package -DskipTests

# ---------- Runtime image ----------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/armaggedonchess-0.0.1-SNAPSHOT.jar /app/app.jar
ENV JAVA_OPTS=""
EXPOSE 8080
CMD ["bash", "-lc", "java $JAVA_OPTS -Dserver.port=${PORT:-8080} -jar /app/app.jar"]
