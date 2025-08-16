# ---------- Build image ----------
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

COPY pom.xml ./
COPY src ./src

# normal build (no go-offline)
RUN mvn -q -e clean package -DskipTests

# ---------- Runtime image ----------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# your jar is produced as armaggedonchess-1.0.0.jar per your logs
COPY --from=build /app/target/armaggedonchess-1.0.0.jar /app/app.jar

# Render provides $PORT; default locally to 8080
ENV JAVA_OPTS=""
EXPOSE 8080
CMD ["bash","-lc","java $JAVA_OPTS -Dserver.port=${PORT:-8080} -jar /app/app.jar"]
