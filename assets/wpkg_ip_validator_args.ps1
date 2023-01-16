# Name: IP Validator 3001
# Description: Used by WPKG packages to check if the provided site ip supernet matches the current ip address of the computer
# Usage: Provide your supernet ip address with -ip argument (eg. script.ps1 -ip 10.191.0.0)
# Purpose: To check if computer is onsite or at home to set different source for the installers
# Author: Danilo Bilanoski
# Date: 16/01/2023


# -- Notes --
# This uses regex patterning to catch desired on-site ip address while avoiding RAVPNS (Cisco AnyConnect)
# Advice is to put your site supernet address to wpkg packages as an variable and call this script with it (eg. script.ps -ip %wpkg-variable%)
# Exit code 500 means machine is onsite, 501 means its not, 2 means you provided empty or wrong formatted ip address with -ip argument


param (
    # This one catches all non-named positional parameters for an exception defined later - not to be used in syntax
    $bad_param,
    # This one takes correctly formatted IPv4 address
    [string]
    # Input your site's supernet address [10.191.0.0 for example]
    $ip
)

# IPv4 pattern
$ipv4 = '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

# If ip address not provided or in wrong format, exit with exit code 2 and alert user
If ($bad_param -or
    $ip -notmatch $ipv4) {
        Write-Error "Please write valid network ip address, eg. 10.191.0.0"
        Exit 2
    }

# Split provided ip to octets
$current_octets = $ip.split(".")

# Get current ip address of active adapter
$ips = (Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.status -ne "Disconnected"}).ipv4address.ipaddress

# Build pattern for validation
$pattern = "^$($current_octets[0]).$($current_octets[1])\.[0-9]?[0-9]?[0-9]\.[0-9]+$"

# Logic for returning exit codes
if ($ips -match $pattern) {EXIT 500} else {EXIT 501}