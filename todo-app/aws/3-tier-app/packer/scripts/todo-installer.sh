#!/bin/bash
set -x

# Install necessary dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
sudo DEBIAN_FRONTEND=noninteractive apt-add-repository universe
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get -y -qq install curl git openjdk-11-jdk maven apt-transport-https ca-certificates

# Setup sudo to allow no-password sudo for "$USER_GROUP" group and adding "$USER" user
sudo groupadd -r $USER_GROUP
sudo useradd -m -s /bin/bash $USER
sudo usermod -a -G $USER_GROUP $USER
sudo cp /etc/sudoers /etc/sudoers.orig
echo "$USER  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER

# Installing SSH key
sudo mkdir -p /home/$USER/.ssh
sudo chmod 700 /home/$USER/.ssh
sudo cp /tmp/todo.pub /home/$USER/.ssh/authorized_keys
sudo chmod 600 /home/$USER/.ssh/authorized_keys
sudo chown -R $USER /home/$USER/.ssh
sudo usermod --shell /bin/bash $USER



# Create JAVA_HOME for $USER & download the todo-app from github

sudo -H -i -u $USER -- env bash << EOF
whoami
echo ~$USER
cd /home/$USER
export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64/
export PATH=$PATH:$JAVA_HOME/bin
git clone https://github.com/Raghav2211/psi-lab.git
cd psi-lab/todo-app
mvn clean package
sudo mkdir /opt/todo
sudo cp target/psi-todo-${APP_VERSION}.jar /opt/todo/app.jar
sudo cp /tmp/todo-bootstrap.sh /opt/todo/bootstrap.sh
sudo chmod 744 /opt/todo/bootstrap.sh
sudo cp /tmp/todo.service /etc/systemd/system/todo.service
sudo mkdir /etc/systemd/system/todo.service.d
sudo chown -R $USER /etc/systemd/system/todo.service.d
sudo echo 'Environment="USER=$USER"' > /etc/systemd/system/todo.service.d/local.conf
sudo cat /etc/systemd/system/todo.service.d/local.conf
EOF

