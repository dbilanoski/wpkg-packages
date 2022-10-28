# Name: IP Validator 3000
# Description: Used by WPKG packages to determine whether machine is on-site or at home
# Author: Danilo Bilanoski
# Date: 17/05/2022

# -- Notes --
# This uses regex patterning to catch desired on-site ip address while avoiding RAVPNS (Cisco AnyConnect).
# Please adjust $pattern variable to match your onsite supernetwork
# Exit code 500 means machine is onsite, 501 means its not

$ips = (Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.status -ne "Disconnected"}).ipv4address.ipaddress
# Example pattern for supernet 10.191.0.0/16
$pattern = "^10\.191\.[0-9]?[0-9]?[0-9]\.[0-9]+$"

if ($ips -match $pattern) {EXIT 500} else {EXIT 501}