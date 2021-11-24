# WPKG Silent Installers & Software Package Scripts

Short collection of wpkg package scripts for various software untattended installations used in professional production environment. Internal logic of packages aims to optimize bandwith consuption in mixed environment where users are connecting both from RA VPNs and on-site networks.

## About packages

Packages are structured as separate files per software and written following these points:
* Variables are used whenever practical (versions, installations switches, product uninstallation keys, download links etc.)
* Software variable is defined on the server side
* Client ip address will be checked first to differentiate vpn users from on-site users

Some packages will have custom validators for "installed" state check. Those are scripts and similar things pushed occassionaly, such as activation of BitLocker or executing time sync script.

Some packages will have underlying batch scripts either as checks or as means of installations. In those cases, batch file will be included as a separate file showing script logic.

Some packages will have custom installation logic for various reasons - pay attention to in-package comments.

## Getting Started

### Package configuration
#### Variables

* PKG_VERSION - version of the program (one showed as a version value of the exe file)  
* SYS_VERSION - version of the program (one showed as a value of the uninstall string)
    * If PKG_VERSION is used, this one will usually be shown as equal to PKG_VERSION as most of the time both are same
    * In some cases, system version might have additional numbers on top ov the PKG_VERSION which is handled in usage as below:
    ```
    <variable name="PKG_VERSION" value="6.4.6" />
	<variable name="SYS_VERSION" value="%PKG_VERSION%.2" />
    <!-- This will give SYS_VERSION value ov 6.4.6.2 -->
    ```
    * Used as a revision number

* PKG_CODE - uninstall string of an msi package (if used)
* DL_LINK (1..9) - Download links (if used)
* PKG_INSWITCHES - Installation switches (if used)

#### Revision
SYS_VERSION variable is used as a reversion. This way, change in the software version variable triggers the appropriate installation action.

#### Priorities
* 90-100, prioritized software
* 50-90, software with no specific priority
* 1-10, installers which are triggering reboots
* default: 30

Always have your priorities sorted in the desired sequnce to achive order which is practical to your application. Advice is to have application which requires a reboot to have the lowest priority. 

### Usage

* Clone repo and copy packages folder content to your wpkg.js folder\packages
* Adjust installation paths and variables to your situation

### Writing new packages
* Use templates from the .\Template folder as a starting point.

## References

* [WPKG Wiki page](https://wpkg.org/Main_Page)
* [Good XML Validator](https://www.liquid-technologies.com/online-xml-validator)
* [About REGEX Syntax](https://docs.microsoft.com/en-us/previous-versions/1400241x(v=vs.100)?redirectedfrom=MSDN)
* [About REGEX Syntax 2](https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference?redirectedfrom=MSDN)

## Help

Always use debugging to check the procedural execution of your setup.
* Best to have a debug script ready on your server
* Best to have it directed to a textual file for readability
  ```
  \\your-path-to-wpkg.js\wpkg.js /synchronize /debug > C:\wpkg-log.txt
  
  ```

## Authors

[Danilo Bilanoski](mailto:danilo.bilanoski@transcom.com)

## Acknowledgments

* [WPKG Silent Installers](https://wpkg.org/Category:Silent_Installers)

## ToDo
- [x] Initial draft, readme file
- [X] Templates for MSI and EXE both with and without IP validation
- [] Revise existing packages