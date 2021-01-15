#!/bin/bash
set -x

# Install necessary dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
sudo DEBIAN_FRONTEND=noninteractive apt-add-repository universe
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get -y -qq install curl git openjdk-11-jdk maven apt-transport-https ca-certificates

# Setup sudo to allow no-password sudo for "psi" group and adding "todo" user
sudo groupadd -r psi
sudo useradd -m -s /bin/bash todo
sudo usermod -a -G psi todo
sudo cp /etc/sudoers /etc/sudoers.orig
echo "todo  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/todo

# Installing SSH key
sudo mkdir -p /home/todo/.ssh
sudo chmod 700 /home/todo/.ssh
sudo cp /tmp/todo.pub /home/todo/.ssh/authorized_keys
sudo chmod 600 /home/todo/.ssh/authorized_keys
sudo chown -R todo /home/todo/.ssh
sudo usermod --shell /bin/bash todo



# Create JAVA_HOME for todo & download the todo-app from github

sudo -H -i -u todo -- env bash << EOF
whoami
echo ~todo
cd /home/todo
export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64/
export PATH=$PATH:$JAVA_HOME/bin
git clone https://github.com/Raghav2211/psi-lab.git
cd psi-lab/todo-app
mvn clean package -DskipTests
sudo mkdir /opt/todo
sudo cp target/psi-todo-${APP_VERSION}.jar /opt/todo/app.jar
sudo cp /tmp/todo-bootstrap.sh /opt/todo/bootstrap.sh
sudo chmod 744 /opt/todo/bootstrap.sh
sudo cp /tmp/todo.service /etc/systemd/system/todo.service
EOF

