#!/bin/bash
set -x

# Install necessary dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
sudo DEBIAN_FRONTEND=noninteractive apt-add-repository universe
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get -y -qq install curl git openjdk-11-jdk maven apt-transport-https ca-certificates

# Setup sudo to allow no-password sudo for "todo" group and adding "springtodo" user
sudo groupadd -r todo
sudo useradd -m -s /bin/bash springtodo
sudo usermod -a -G todo springtodo
sudo cp /etc/sudoers /etc/sudoers.orig
echo "springtodo  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/springtodo

# Installing SSH key
sudo mkdir -p /home/springtodo/.ssh
sudo chmod 700 /home/springtodo/.ssh
sudo cp /tmp/todo.pub /home/springtodo/.ssh/authorized_keys
sudo chmod 600 /home/springtodo/.ssh/authorized_keys
sudo chown -R springtodo /home/springtodo/.ssh
sudo usermod --shell /bin/bash springtodo



# Create JAVA_HOME for todo & download the todo-app from github

sudo -H -i -u springtodo -- env bash << EOF
whoami
echo ~springtodo
cd /home/springtodo
export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64/
export PATH=$PATH:$JAVA_HOME/bin
git clone https://github.com/Raghav2211/spring-web-flux-todo-app.git
cd spring-web-flux-todo-app
mvn clean package -DskipTests
APP_VERSION=$(mvn help:evaluate -q -DforceStdout -D"expression=project.version")
sudo mkdir /opt/todo
sudo cp target/todo-${APP_VERSION}.jar /opt/todo/app.jar
sudo cp /tmp/bootstrap.sh /opt/todo/bootstrap.sh
sudo chmod 744 /opt/todo/bootstrap.sh
sudo cp /tmp/app.service /etc/systemd/system/todo.service
cd ..
rm -r spring-web-flux-todo-app
EOF