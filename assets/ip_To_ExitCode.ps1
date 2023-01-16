# Name: IP to Exit Code 3000
# Description: Used by WPKG packages to determine subnet used and sets the exit code to second octet of the IP address
# Author: Danilo Bilanoski
# Date: 04/11/2022


# -- Notes --
# This will check all active ip addresses on the pc and set the exit code to be the second octet of the ip address of specified adapter
# Example: you have two adapters, you check each by executing script as:
    # ip_To_ExitCode.ps1 -adapter 1
        # Script will check adapter one ip address
        # Say its 10.191.10.22
        # It will remove dots, take second octet (191) and but it as exit code 
    # ip_To_ExitCode.ps1 -adapter 2
        # Script will check adapter one ip address
        # Say its 172.16.10.22
        # It will remove dots, take second octet (172) and but it as exit code 
# In wpkg conditionals, you can execute this and by specifyng the second octet of your site as the exit code and have it confirm if machine is onsite


param (
    # This one catches all non-named positional parameters for an exception defined later - not to be used in syntax
    $bad_param,
    # This one accepts either 1 or 2, for checking the IP when there is a second network adapter
    [string]
    # Input ordinal number of desired network adapter (1 or 2)
    $adapter
)


# If argument adapter is not used with accepted values, exit 2
If ($bad_param -or
    $adapter -lt 1 -or
    $adapter -gt 2) {
        Write-Error "Please use adapter argument with either 1 or 2 for desired network adapter."
        Exit 2
    }

$ips = ((Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.status -ne "Disconnected"}).ipv4address.ipaddress).split(".")

if ($adapter -eq 1) {exit $ips[1]}
if ($adapter -eq 2) {exit $ips[5]}