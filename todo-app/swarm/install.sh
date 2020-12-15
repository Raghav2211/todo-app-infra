#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        docker-machine --version &> /dev/null || { echo "Installing docker-machine....."; curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
        chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine; }
elif [[ "$OSTYPE" == "darwin"* ]]; then
        docker-machine --version &> /dev/null || { echo "Installing docker-machine....."; curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
  		chmod +x /usr/local/bin/docker-machine; }
elif [[ "$OSTYPE" == "msys" ]]; then
        docker-machine --version &> /dev/null || { echo "Installing docker-machine....."; if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi && \
		curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" && \
		chmod +x "$HOME/bin/docker-machine.exe"; }
else
        echo "Unknown OS"
        exit 1;
fi