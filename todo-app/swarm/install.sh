#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        docker-machine --version &> /dev/null || { echo "Installing docker-machine....."; curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
        chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine; }
elif [[ "$OSTYPE" == "darwin"* ]]; then
  		  brew --version &> /dev/null || 
        { 
          echo "Installing brew....."; 
          curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh; 
        }
        docker-machine --version &> /dev/null || 
        { 
          echo "Installing docker-machine....."; 
          curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
            chmod +x /usr/local/bin/docker-machine; 
        }
    		vboxmanage --version &> /dev/null || 
        { 
    			read -p "Do you wish to install virtualbox[Y/n]?" in; 
    			case ${in:0:1} in
  			    y|Y )
  			        brew cask install virtualbox
  			    ;;
  			    n/N )
  			        echo "VirtualBox not installed"
  			    ;;
  			  esac
    		}
elif [[ "$OSTYPE" == "msys" ]]; then
        docker-machine --version &> /dev/null || 
        { 
          echo "Installing docker-machine....."; 
          if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi && \
		        curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" && \
              chmod +x "$HOME/bin/docker-machine.exe"; 
        }
    		chmod +x ChocolateyInstallNonAdmin.ps1
        powershell.exe -ExecutionPolicy RemoteSigned -File './ChocolateyInstallNonAdmin.ps1'
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
else
        echo "Unknown OS"
        exit 1;
fi
echo "=================================================="
echo "Docker machine installed ---  $(docker-machine --version | awk '{split($0,a," "); print a[3]}' | sed 's/.$//')"
echo "VirtualBox installed     ---  $( vboxmanage --version )"
echo "=================================================="