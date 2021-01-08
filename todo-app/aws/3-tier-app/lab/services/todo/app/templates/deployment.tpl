#!/bin/bash -x

export MYSQL_HOST='${MYSQL_HOST}'
export MYSQL_DB_NAME='${MYSQL_DB_NAME}'
export MYSQL_USER='${MYSQL_USER}'
export MYSQL_PASSWORD='${MYSQL_PASSWORD}'

# bootstrap todo app
java -jar /opt/app.jar