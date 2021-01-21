#!/bin/bash
sudo adduser --disabled-password --gecos '' ${username}
sudo mkdir -p /home/${username}/.ssh
sudo touch /home/${username}/.ssh/authorized_keys
sudo echo '${public_key}' > authorized_keys
sudo mv authorized_keys /home/${username}/.ssh
sudo chown -R ${username}:${username} /home/${username}/.ssh
sudo chmod 700 /home/${username}/.ssh
sudo chmod 600 /home/${username}/.ssh/authorized_keys
sudo usermod -aG sudo ${username}