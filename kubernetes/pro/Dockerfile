FROM openjdk:8-jre-alpine
COPY ./target/*.jar hi-class-api.jar
COPY scouter/ scouter
CMD ["java", "-jar", "-XX:MaxMetaspaceSize=512m", "-XX:MetaspaceSize=256m", "-Xms4096m", "-Xmx4096m", "-Dscouter.config=/scouter/conf/api.conf", "-javaagent:/scouter/scouter.agent.jar", "/hi-class-api.jar"]
EXPOSE 19081
