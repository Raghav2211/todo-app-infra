#!/bin/bash -x

# Export mysql environment variables
systemctl set-environment MYSQL_HOST=${MYSQL_HOST}
systemctl set-environment MYSQL_DB_NAME=${MYSQL_DB_NAME}
systemctl set-environment MYSQL_USER=${MYSQL_USER}
systemctl set-environment MYSQL_PASSWORD=${MYSQL_PASSWORD}


# bootstrap todo app
sudo systemctl daemon-reload
sudo systemctl enable todo.service
sudo systemctl start todo