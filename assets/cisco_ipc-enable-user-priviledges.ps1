# Author: Danilo Bilanoski
# Description: Allow non-administrative users to edit settings in Cisco IP Communicator

$acl = Get-Acl "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator"
$person = [System.Security.Principal.NTAccount]"Authenticated Users"         
$access = [System.Security.AccessControl.RegistryRights]"FullControl"
$inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
$propagation = [System.Security.AccessControl.PropagationFlags]"None"
$type = [System.Security.AccessControl.AccessControlType]"Allow"

$rule = New-Object System.Security.AccessControl.RegistryAccessRule($person,$access,$inheritance,$propagation,$type)

$acl.AddAccessRule($rule)

$acl |Set-Acl