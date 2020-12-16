# #!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

check_install_brew() {
  brew --version &> /dev/null || 
  { 
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh; 
  }
}

install_choco() {
  chmod +x ChocolateyInstallNonAdmin.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './ChocolateyInstallNonAdmin.ps1'
}

install_docker_machine_linux() {
  docker-machine --version &> /dev/null || 
  { 
    curl -L -s https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine && 
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine; 
  }
}

install_docker_machine_darwin() {
  docker-machine --version &> /dev/null || 
  { 
    curl -L -s https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine; 
  }
}

install_docker_machine_win() {
  docker-machine --version &> /dev/null || 
  { 
    if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi && \
    curl -L -s https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" && \
    chmod +x "$HOME/bin/docker-machine.exe"; 
  }
}

install_virtualbox_darwin() {
  vboxmanage --version &> /dev/null || 
  { 
    read -p "Do you wish to install virtualbox[Y/n]?" in; 
    case ${in:0:1} in
      y|Y )
          export HOMEBREW_NO_AUTO_UPDATE=1
          brew cask --quiet install virtualbox
      ;;
      n/N )
          echo "VirtualBox not installed"
      ;;
    esac
  }
}

install_virtualbox_win() {
  install_choco
  vboxmanage --version &> /dev/null || 
  { 
    read -p "Do you wish to install virtualbox[Y/n]?" in; 
    case ${in:0:1} in
      y|Y )              
          choco install virtualbox
      ;;
      n/N )
          echo "VirtualBox not installed"
      ;;
    esac
  }    
}

install_docker_machine() {
  echo "Installing dokcer-machine....."
 if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_docker_machine_linux 
 elif [[ "$OSTYPE" == "darwin"* ]]; then 
    check_install_brew
    install_docker_machine_darwin
 elif [[ "$OSTYPE" == "msys" ]]; then    
    install_docker_machine_win
 fi

}

install_virtualbox() {
  echo "Installing virtualbox....."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "TODO"
 elif [[ "$OSTYPE" == "darwin"* ]]; then 
    install_virtualbox_darwin
 elif [[ "$OSTYPE" == "msys" ]]; then    
    install_virtualbox_win
 fi
}

help() {
    echo "Usage:    ${me} [OPTIONS] COMMAND"
    echo ""
    echo "Author:"
    echo "   PSI Lab Contributors - <$(git config --get remote.origin.url)>"
    echo ""
    echo "Options:"
    echo " --install, -i                    Install specific tool/dependency for docker-swarm cluster"
    echo " --help, -h                       show help"
    echo ""
    echo "Commands:"
    echo " all                              Install all dependencies" 
    echo " virtualbox                       Install Virtualbox" 
    echo " docker-machine                   Install Docker machine" 
}

case $1 in

  --install|-i)
          case $2 in

            virtualbox) 
              install_virtualbox
              ;;
            docker-machine)
              install_docker_machine
              ;;
            all)
              install_docker_machine
              install_virtualbox
              ;;  
            *)
              echo "Unrecognized option : ${2}" 
              help 
              exit 1
              ;;
          esac    
          ;;
  --help|-h)
          help
          ;;
   *)
          echo "Unrecognized option : ${1}"
          help
          exit 1
          ;;       

esac
echo "=================================================="
echo "Docker machine installed ---  $(docker-machine --version | awk '{split($0,a," "); print a[3]}' | sed 's/.$//')"
echo "VirtualBox installed     ---  $( vboxmanage --version )"
echo "=================================================="