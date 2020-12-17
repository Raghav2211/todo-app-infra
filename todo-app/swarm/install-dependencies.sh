# #!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

install_helpers_linux() {
  echo "Install helper libraries(curl,sysfsutils)....."  
  curl --version &> /dev/null || { echo "Installing curl...."; apt-get -qq update; apt-get install -qy curl sysfsutils 1> /dev/null; }
}

install_helpers_darwin() {
  echo "Install helper libraries(brew)....."
  brew --version &> /dev/null || { curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh; }
}

install_helpers_win() {
  echo "Install helper libraries(choco)....."  
  chmod +x ChocolateyInstallNonAdmin.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './ChocolateyInstallNonAdmin.ps1'
}

install_docker_machine_linux() {
  install_helpers_linux
  docker-machine --version &> /dev/null || 
  { 
    echo "Installing dokcer-machine....."
    curl -L -s https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    sudo chmod +x /tmp/docker-machine && 
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine; 
  }
}

install_docker_machine_darwin() {
  install_helpers_darwin
  docker-machine --version &> /dev/null || 
  { 
    echo "Installing dokcer-machine....."
    curl -L -s https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine; 
  }
}

install_docker_machine_win() {
  docker-machine --version &> /dev/null || 
  { 
    echo "Installing dokcer-machine....."
    if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi && \
    curl -L -s https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" && \
    chmod +x "$HOME/bin/docker-machine.exe"; 
  }
}

install_virtualbox_linux() {
  install_helpers_linux
  vboxmanage --version &> /dev/null || 
  { 
      if systool -m kvm_amd -v &> /dev/null || systool -m kvm_intel -v &> /dev/null ; then
        echo "AMD-V / VT-X is enabled"
      else
        read -p "Virtualization not support, do you wish to install virtualbox[Y/n]?" in; 
        case $in in
          y|Y) ;;
          *) exit 1 ;; 
        esac
      fi
      echo "Installing virtualbox....."
      sudo apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq update && sudo apt install -qqy --no-install-recommends virtualbox;
  }
}

install_virtualbox_darwin() {
  vboxmanage --version &> /dev/null || 
  {
    # Check whether os support vitualization 
    if [[ "$(sysctl kern.hv_support | awk '{split($0,a,": "); print a[2]}')" != 1 ]] ; then
      read -p "Virtualization not support, do you wish to install virtualbox[Y/n]?" in; 
      case $in in
        y|Y) ;;
        *) exit 1 ;; 
      esac
    fi
    install_helpers_darwin
    echo "Installing virtualbox....."
    export HOMEBREW_NO_AUTO_UPDATE=1; brew install --quiet virtualbox;     
  }
}

install_virtualbox_win() {
  install_helpers_win
  vboxmanage --version &> /dev/null || 
  { 
    read -p "Do you wish to install virtualbox[Y/n]?" in; 
    case ${in:0:1} in
      y|Y ) 
          echo "Installing virtualbox....."             
          choco install virtualbox
      ;;
      n|N )
          exit 1
      ;;
    esac
  }    
}

install_docker_machine() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_docker_machine_linux 
  elif [[ "$OSTYPE" == "darwin"* ]]; then 
    install_docker_machine_darwin
  elif [[ "$OSTYPE" == "msys" ]]; then    
    install_docker_machine_win
  fi

}

install_virtualbox() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_virtualbox_linux
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
              exit 128
              ;;
          esac    
          ;;
  --help|-h)
          help
          ;;
   *)
          echo "Unrecognized option : ${1}"
          help
          exit 128
          ;;       

esac