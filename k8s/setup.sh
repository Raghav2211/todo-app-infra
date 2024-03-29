# #!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

exit_if_fail(){
  ret=$?
  if [ $ret -ne 0 ]; then
  echo "entering if.."
  exit $ret
  fi
}

install_helpers_darwin() {
  brew --version &> /dev/null || { eval $(if [ "$debug" -eq 1 ]; then echo "curl -fSL"; else echo "curl -fsSL"; fi) https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh; echo -e "\xE2\x9C\x94 Installed helper libraries(brew)\n";exit_if_fail; }
}

install_helpers_win() {
  echo "Install helper libraries(choco)....."  
  chmod +x ChocolateyInstallNonAdmin.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './ChocolateyInstallNonAdmin.ps1'
  exit_if_fail
}

enable_hyperv_win(){
  echo "Enabling Hyper-V if not enabled....."  
  chmod +x EnableHyperV.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './EnableHyperV.ps1'
  exit_if_fail;
}
create_internal_swtich(){
  chmod +x CreateInternalSwitch.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './CreateInternalSwitch.ps1'
  exit_if_fail;
}

install_helm_darwin() {
  helm version &> /dev/null || { echo "Installing helm....."; HOMEBREW_NO_AUTO_UPDATE=1 eval $(if [ "$debug" -eq 1 ]; then echo "brew install -dv"; else echo "brew install -q"; fi) helm;exit_if_fail; }
  echo -e "\xE2\x9C\x94 Helm -- $( helm version | awk '{split($0,a," "); print a[1]}' | awk '{split($0,a,":"); print a[2]}'| sed 's/.$//' )";
}

install_minikube_darwin() {
  minikube version &> /dev/null || { echo "Installing minikube....."; HOMEBREW_NO_AUTO_UPDATE=1 eval $(if [ "$debug" -eq 1 ]; then echo "brew install -dv"; else echo "brew install -q"; fi) minikube; exit_if_fail;}
  echo -e "\xE2\x9C\x94 Minikube -- $( minikube version | awk '{split($0,a," "); print a[3]}' )";
}

boot_minikube_darwin() {
  install_helpers_darwin
  install_helm_darwin
  install_minikube_darwin
  minikube start --mount-string="$(pwd)/../env/local/kms:/kms" --kubernetes-version=v1.19.2 --mount;
  exit_if_fail;
}

boot_minikube_win() {
  enable_hyperv_win
  install_helpers_win
  docker --version &> /dev/null || { echo "Installing docker for windows.....";choco install docker-for-windows –pre; exit_if_fail;}
  minikube --version &> /dev/null || { echo "Installing minikube for windows.....";choco install minikube;exit_if_fail; }
  helm --version &> /dev/null || { echo "Installing helm for windows.....";choco install kubernetes-helm;exit_if_fail; }
  create_internal_swtich
  minikube start --mount-string="$(pwd)/../env/local/kms:/kms" --kubernetes-version=v1.19.2 — vm-driver=”hyperv” — hyperv-virtual-switch=”minikube” --mount;
  exit_if_fail;
}


boot_local() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "TODO -- Install miinikube & helm"
  elif [[ "$OSTYPE" == "darwin"* ]]; then 
    boot_minikube_darwin
  elif [[ "$OSTYPE" == "msys" ]]; then    
    boot_minikube_win
  fi
  exit 0;
}

help() {
    echo "Usage:    ${me} [OPTIONS] COMMAND"
    echo ""
    echo "Author:"
    echo "   TODO APP INFRA Contributors - <$(git config --get remote.origin.url)>"
    echo ""
    echo "Options:"
    echo " --debug, -D                      Enable debug mode"
    echo " --help, -h                       show help"
    echo ""
    echo "Commands:"
    echo " bootlocal                        Install and Start Minikube on local"
}

debug=0 # disable debug 

if [ $# -lt 1 ]; then
    help
fi


while test -n "$1"; do
   case "$1" in
      --debug|-D)
         if [[ $# -eq 1 ]]; then
		 	    help
		    fi	 
         debug=1 # enable debug 
         shift
         ;;
       bootlocal)
         if [[ $# -gt 1 ]]; then
          echo "Too many args";
          exit 1;  
         fi   
         boot_local
         shift
         ;;  
       *) 
          echo "Unrecognized option : ${1}"
          help
          exit 1;  
   esac
done
debug=0 # disable debug 