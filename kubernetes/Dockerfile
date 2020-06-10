FROM openjdk:8-jre-alpine
COPY ./target/*.jar hi-class-api.jar
CMD ["java", "-jar", "/hi-class-api.jar", "-XX:MaxMetaspaceSize=512m", "-XX:MetaspaceSize=256m", "-Xms1024m", "-Xmx1024m"]
EXPOSE 19081
