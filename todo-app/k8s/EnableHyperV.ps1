# Check and Enable Hyper-V If not enabled
if ((Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ne 'Enabled')
{
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
}