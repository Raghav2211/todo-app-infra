# #!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

install_helpers_win() {
  echo "Install helper libraries(choco)....."  
  chmod +x ChocolateyInstallNonAdmin.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './ChocolateyInstallNonAdmin.ps1'
}

enable_hyperv_win(){
  echo "Enabling Hyper-V if not enabled....."  
  chmod +x EnableHyperV.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './EnableHyperV.ps1'
}
create_internal_swtich(){
  echo "Creating Virtual Switch of type Internal....."  
  chmod +x CreateInternalSwitch.ps1
  powershell.exe -ExecutionPolicy RemoteSigned -File './CreateInternalSwitch.ps1'
}
install_start_minikube_win() {
  enable_hyperv_win
  install_helpers_win
  docker --version &> /dev/null || 
  { 
    choco install docker-for-windows –pre
  }
  minikube --version &> /dev/null || 
  { 
    choco install minikube
  }
  create_internal_swtich
  minikube start — vm-driver=”hyperv” — hyperv-virtual-switch=”minikube” — v=7 — alsologtostderr
      
}


install_start_minikube() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_virtualbox_linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then 
    install_virtualbox_darwin
  elif [[ "$OSTYPE" == "msys" ]]; then    
    install_start_minikube_win
  fi
}

help() {
    echo "Usage:    ${me} [OPTIONS] COMMAND"
    echo ""
    echo "Author:"
    echo "   PSI Lab Contributors - <$(git config --get remote.origin.url)>"
    echo ""
    echo "Options:"
    echo " --debug, -D                      Enable debug mode"
    echo " --help, -h                       show help"
    echo ""
    echo "Commands:"
    echo " bootlocal                        Install and Start Minikube"
}

debug=0

if [ $# -lt 1 ]; then
    help
fi


while test -n "$1"; do
   case "$1" in
      --debug|-D)
         debug=1
         shift
         ;;
       bootlocal)
         if [[ $# -gt 1 ]]; then
          echo "Too many args";
          exit 1;  
         fi   
         install_start_minikube
         shift
         ;;  
       *) 
          echo "Unrecognized option : ${1}"
          help
          exit 1;  
   esac
done