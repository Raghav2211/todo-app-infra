#!/bin/sh
java -server -Dfile.encoding=utf-8 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom -Duser.timezone=UTC -jar /opt/todo/app.jar