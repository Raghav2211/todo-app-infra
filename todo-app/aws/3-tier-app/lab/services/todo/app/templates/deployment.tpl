#!/bin/bash -x

# Export mysql environment variables
export MYSQL_HOST='${MYSQL_HOST}'
export MYSQL_DB_NAME='${MYSQL_DB_NAME}'
export MYSQL_USER='${MYSQL_USER}'
export MYSQL_PASSWORD='${MYSQL_PASSWORD}'

# bootstrap todo app
sudo systemctl daemon-reload
sudo systemctl enable todo.service
sudo systemctl start todo