# WPKG Silent Installers & Software Package Scripts

A curated collection of **WPKG package definitions and helper scripts** used for unattended software deployment in a professional production environment.

These packages were designed and used at scale, with a strong focus on **reliability**, **bandwidth efficiency**, and **zero-impact deployments** across mixed connectivity scenarios (on-site networks and remote-access VPN users).

---

## Purpose & design goals

This repository reflects real-world deployment challenges rather than lab-perfect scenarios.  
Key design goals include:

- Unattended, repeatable software installations
- Optimized bandwidth usage for remote users
- Clear versioning and revision control
- Minimal disruption to production environments
- Explicit, readable logic over hidden or “magic” behavior

Several packages include conditional logic to differentiate **on-site vs. off-site installations**, ensuring the most efficient installation path is used in each case.

---

## Package structure & conventions

Packages are structured as **one file per application**, following consistent conventions:

- Variables are used wherever practical:
  - Versions
  - Installation switches
  - Uninstall strings
  - Download URLs and targets
- `SOFTWARE` variable is defined server-side (WPKG configuration)
- Client IP detection is performed early to distinguish VPN users from on-site machines
- Custom validators are used where a simple MSI check is insufficient

Some packages include:
- External batch or PowerShell scripts (included in the repo)
- One-time execution logic (e.g. BitLocker enablement, post-install actions)
- Custom install or validation logic explained directly in package comments

When something deviates from the "standard" flow, it should be documented.

---

## On-site vs off-site detection (important note)

### ⚠️ About IP address as a WPKG host attribute

Using the registry-based approach:

`HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\`

in combination with:

`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards\`

often results in **arrays of historical IP addresses**, including inactive adapters. Because of this, registry-based IP detection is **not reliable** for determining current network location.

This approach was tested in production and discarded due to inconsistent results.

### Recommended approach: PowerShell-based IP validation

The following PowerShell script detects whether a machine is currently connected to an internal network based on its active IPv4 address.

Example:
- Internal network: `10.10.0.0/16`
- Exit code `500` → on-site
- Exit code `501` → off-site

```powershell
$ips = (Get-NetIPConfiguration |
  Where-Object {
    $_.IPv4DefaultGateway -ne $null -and
    $_.NetAdapter.Status -ne "Disconnected"
  }).IPv4Address.IPAddress

$pattern = "^10\.10\.[0-9]{1,3}\.[0-9]+$"

if ($ips -match $pattern) {
  exit 500
} else {
  exit 501
}
```
Used as a condition in WPKG:

```xml
<!-- On-site installation -->
<install cmd="msiexec /i /switches %SOFTWARE%\app\app.msi">
  <condition>
    <check type="execute"
           path="powershell.exe -executionpolicy bypass -File \\path\ip_validator.ps1"
           condition="exitcodeequalto"
           value="500" />
  </condition>
</install>

<!-- Off-site installation -->
<install cmd="msiexec /i /switches %DL_TARGET%\app.msi">
  <condition>
    <check type="execute"
           path="powershell.exe -executionpolicy bypass -File \\path\ip_validator.ps1"
           condition="exitcodeequalto"
           value="501" />
  </condition>
</install>

```

## Variables & configuration

Commonly used variables include:

- `PKG_VERSION` – application version
- `SYS_VERSION` – system / uninstall version (used as revision trigger)
  - Can extend `PKG_VERSION` if needed:
    ```xml
    <variable name="PKG_VERSION" value="6.4.6" />
    <variable name="SYS_VERSION" value="%PKG_VERSION%.2" />
    ```
- `UNINSTALL_STRING` – uninstall command (if applicable)
- `DL_SOURCE_(1..9)` – download URLs
- `DL_TARGET_(1..9)` – download targets
  - Stored in `%TEMP%` by default
  - Subfolders are supported (e.g. `appname\installer.exe`)
- `INSTALL_ARGS` – installer command-line switches
- `PS_SCRIPT` / `*_SCRIPT` – external PowerShell helper scripts
- `IP_SITE_SUPERNET` – internal network supernet (e.g. `10.10.0.0`)

### Revision handling

`SYS_VERSION` acts as the revision trigger.  
Updating this value forces re-evaluation and reinstallation when appropriate.

---

## Package priorities

Recommended priority ranges:

- **90–100** – critical or prioritized software
- **50–90** – standard software
- **1–10** – installers that trigger reboots
- **Default** – 30

Reboot-requiring packages should generally have the **lowest priority** aiming for a reboot at the finish (no interuptions).

---

## Getting started

Clone the repository and copy required packages into your WPKG setup:

```bash
git clone https://github.com/dbilanoski/wpkg-packages.git
```
Adjust installation paths, variables, and scripts to match your environment.

## Writing new packages

- Use templates from the `Template` directory as a starting point
- Follow existing variable naming and structural conventions
- Document any non-obvious or custom logic directly inside the package file

## Debugging & troubleshooting

Always validate procedural execution using debug output:
```bash
\\path-to-wpkg.js\wpkg.js /synchronize /debug > C:\wpkg-log.txt

```
Redirecting output to a text file makes analysis significantly easier.

## References

* [WPKG Wiki page](https://wpkg.org/Main_Page)
* [WPKG Silent Installers](https://wpkg.org/Category:Silent_Installers)
* [Good XML Validator](https://www.liquid-technologies.com/online-xml-validator)
* [About REGEX Syntax](https://docs.microsoft.com/en-us/previous-versions/1400241x(v=vs.100)?redirectedfrom=MSDN)
* [About REGEX Syntax 2](https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference?redirectedfrom=MSDN)


This repository reflects real operational patterns rather than generic examples. If you’re running WPKG in a mixed on-site / remote environment, you may find these patterns directly reusable.