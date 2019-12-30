#!/bin/bash
export DATE=`date +%Y%m%d_%H%M%S`

# Tomcat 환경 설정
export JAVA_HOME=/usr/java/jdk1.8.0_152
export SERVER_NAME=instance01
export CATALINA_HOME=/home/sigongweb/tomcat8
export CATALINA_BASE=/home/sigongweb/instance/${SERVER_NAME}
export PORT_OFFSET=100
export SCOUTER_AGENT_DIR="/home/obj1/scouter/agent.java"

# Tomcat log 설정
export LOG_BASE=${CATALINA_BASE}/logs
export LOG_DIR=${LOG_BASE}/log
export GC_LOG_DIR=${LOG_BASE}/gclog
export HEAP_DUMP_DIR=${LOG_BASE}/heaplog


# Tomcat Port 설정
export HTTP_PORT=$(expr 8080 + $PORT_OFFSET)
export AJP_PORT=$(expr 8009 + $PORT_OFFSET)
export SSL_PORT=$(expr 8443 + $PORT_OFFSET)
export SHUTDOWN_PORT=$(expr 8005 + $PORT_OFFSET)

# Tomcat JVM Options
if [ "x$JAVA_OPTS" = "x" ]; then
  JAVA_OPTS="$JAVA_OPTS -Xms2048m -Xmx2048m"
  JAVA_OPTS="$JAVA_OPTS -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m"
  JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC"
  JAVA_OPTS="$JAVA_OPTS -XX:+UnlockDiagnosticVMOptions"
  JAVA_OPTS="$JAVA_OPTS -XX:+G1SummarizeConcMark"
  JAVA_OPTS="$JAVA_OPTS -XX:InitiatingHeapOccupancyPercent=35"

  JAVA_OPTS="-server"
  JAVA_OPTS="$JAVA_OPTS -Dserver=$SERVER_NAME"
  JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.http=$HTTP_PORT"
  JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.ajp=$AJP_PORT"
  JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.https=$SSL_PORT"
  JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.shutdown=$SHUTDOWN_PORT"
  JAVA_OPTS="$JAVA_OPTS -Djava.library.path=$CATALINA_HOME/lib/"
  JAVA_OPTS="$JAVA_OPTS -verbose:gc"
  JAVA_OPTS="$JAVA_OPTS -Xloggc:${GC_LOG_DIR}/gc.log"
  JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCDetails"
  JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCTimeStamps"
  JAVA_OPTS="$JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
  JAVA_OPTS="$JAVA_OPTS -XX:HeapDumpPath=${HEAP_DUMP_DIR}/java_pid.hprof"
fi

# Tomcat JMX monitoring
#export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote=true"
#export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=18888"
#export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
#export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
#export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.access.file=$CATALINA_BASE/conf/jmxremote.access"
#export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.password.file=$CATALINA_BASE/conf/jmxremote.password"
#export JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"
#JAVA_OPTS="$JAVA_OPTS -Dsun.rmi.dgc.client.gcInterval=3600000"
#JAVA_OPTS="$JAVA_OPTS -Dsun.rmi.dgc.server.gcInterval=3600000"
#JAVA_OPTS="$JAVA_OPTS -Dsun.lang.ClassLoader.allowArraySyntax=true"
#JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true"
#JAVA_OPTS="$JAVA_OPTS -Djava.security.egd=file:/dev/./urandom"
#export JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=1.209.6.225"

# Scouter
export JAVA_OPTS="${JAVA_OPTS} -javaagent:${SCOUTER_AGENT_DIR}/scouter.agent.jar"
export JAVA_OPTS="${JAVA_OPTS} -Dscouter.config=${SCOUTER_AGENT_DIR}/conf/${SERVER_NAME}.conf"
export JAVA_OPTS="${JAVA_OPTS} -Dobj_name=${SERVER_NAME}"

export JAVA_OPTS

echo "================================================"
echo "JAVA_HOME=$JAVA_HOME"
echo "CATALINA_HOME=$CATALINA_HOME"
echo "SERVER_HOME=$CATALINA_BASE"
echo "HTTP_PORT=$HTTP_PORT"
echo "SSL_PORT=$SSL_PORT"
echo "AJP_PORT=$AJP_PORT"
echo "SHUTDOWN_PORT=$SHUTDOWN_PORT"
echo "================================================"
