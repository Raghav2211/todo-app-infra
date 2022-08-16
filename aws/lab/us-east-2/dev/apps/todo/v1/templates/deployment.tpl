#!/bin/bash -x

# Export mysql environment variables
sudo systemctl set-environment MYSQL_HOST=${MYSQL_HOST}
sudo systemctl set-environment MYSQL_DB_NAME=${MYSQL_DB_NAME}
sudo systemctl set-environment MYSQL_USER=${MYSQL_USER}
sudo systemctl set-environment MYSQL_PASSWORD=${MYSQL_PASSWORD}


# bootstrap todo app
sudo systemctl daemon-reload
sudo systemctl enable todo.service
sudo systemctl start todo