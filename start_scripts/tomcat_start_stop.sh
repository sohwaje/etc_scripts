#!/bin/bash
SERVER_NAME=tomcat7
TOMCAT_USER=sigongweb
SHUTDOWN_WAIT=10
UNAME=`id -u -n`

export CATALINA_HOME=/home/sigongweb/tomcat7
export CATALINA_BASE=/home/sigongweb/tomcat7


tomcat_pid() {
    echo `ps aux | grep "$CATALINA_BASE[ ]" | grep -v grep | awk '{ print $2 }'`
}

start() {
    pid=$(tomcat_pid)

    if [ -n "$pid" ]
    then
        echo "Tomcat is already running (pid: $pid)"
    else
        echo "Starting tomcat (pid: $pid)"

        if [ e$UNAME = "eroot" ]
        then
            /bin/su -p -s /bin/sh $TOMCAT_USER $CATALINA_HOME/bin/startup.sh
        else
            $CATALINA_HOME/bin/startup.sh
        fi
    fi

    return 0
}

stop() {
    pid=$(tomcat_pid)

    if [ -n "$pid" ]
    then
        echo "Stoping Tomcat"

        if [ e$UNAME = "eroot" ]
        then
            /bin/su -p -s /bin/sh $TOMCAT_USER $CATALINA_HOME/bin/shutdown.sh
        else
            $CATALINA_HOME/bin/shutdown.sh -force
        fi

        let kwait=$SHUTDOWN_WAIT
        count=0;
        until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
        do
            echo -n -e "\nwaiting for processes to exit (pid: $pid)\n";
            sleep 1
            let count=$count+1;
        done

        if [ $count -gt $kwait ]; then
            echo -n -e "\nkilling processes which didn't stop after $SHUTDOWN_WAIT seconds (pid: $pid)"
            kill -9 $pid
        fi
    else
        echo "Tomcat is not running"
    fi

    return 0
}

case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        pid=$(tomcat_pid)
        if [ -n "$pid" ]
        then
            echo "Tomcat is running with pid: $pid"
        else
            echo "Tomcat is not running"
        fi
        ;;
    *)
        echo $"Usage : $0 {start|stop|restart}"
        exit 1
esac
exit 0
