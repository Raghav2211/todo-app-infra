# Create an internal switch if not present
If ( ! ( Get-VMSwitch | Where {$_.Name -eq "minikube"} ) ) {
    echo "Creating Virtual Switch of type Internal..."
    New-VMSwitch -name minikube -SwitchType Internal
}