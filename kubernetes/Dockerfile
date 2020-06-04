FROM openjdk:8-jre-alpine
COPY ./hi-class-ui-20191023.jar hi-class-ui-20191023.jar
CMD ["java", "-jar", "/hi-class-ui-20191023.jar", "-XX:MaxMetaspaceSize=512m", "-XX:MetaspaceSize=256m", "-Xms1024m", "-Xmx1024m"]
EXPOSE 19082
