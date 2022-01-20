# WPKG Silent Installers & Software Package Scripts

Short collection of wpkg package scripts for various software untattended installations used in professional production environment. Internal logic of packages aims to optimize bandwith consuption in mixed environment where users are connecting both from RA VPNs and from on-site networks.

## About packages

Packages are structured as separate files per software and written following these points:
* Variables are used whenever practical (versions, installations switches, product uninstallation keys, download links etc.)
* SOFTWARE variable is defined on the server side
* Client IP address will be checked first to differentiate vpn users from on-site users

Some packages will have custom validators for "installed" state check. Those are scripts and similar things pushed occassionaly, such as activation of BitLocker or executing one-time batch scripts.

Some packages will have underlying batch scripts either as checks or as means of installations. In those cases, batch file will be included as a separate file showing script logic.

Some packages will have custom installation logic for various reasons - pay attention to in-package comments.

## Getting Started

### Package configuration
#### Variables

* PKG_VERSION - version of the program (one showed as a version value of the exe file).  
* SYS_VERSION - version of the program (one showed as a value of the uninstall string)
    * If PKG_VERSION is used, this one will usually be shown as equal to PKG_VERSION as most of the time both are same
    * In some cases, system version might have additional numbers on top ov the PKG_VERSION which is handled in usage as below:
    ```
    <variable name="PKG_VERSION" value="6.4.6" />
	<variable name="SYS_VERSION" value="%PKG_VERSION%.2" />
    <!-- This will give SYS_VERSION value ov 6.4.6.2 -->
    ```
    * Used as a revision number

* UNINST_STRING - uninstall string of an msi package (if used)
* DL_LINK (1..9) - Download links (if used)
* TARG_STRING1 - name of the files we are downloading from DL_LINK(1-9)
  * These are by default stored in %TEMP% and later deleted
  * You can add folders to the path (eg. TARG_STRING1 value ="appname\app.exe", this will download file to %TEMP%\appname\app.exe)
* INST_SWITCHES - Installation switches (if used)

#### Revision
SYS_VERSION variable is used as a revision. This way, change in the software version variable triggers the appropriate installation action.

#### Priorities
* 90-100, prioritized software.
* 50-90, software with no specific priority.
* 1-10, installers which are triggering reboots.
* Default: 30.

Always have your priorities sorted in the desired sequence to achive order which is practical to your application. Advice is to have application which requires a reboot with lowest priority. 

### Usage

* Clone repo and copy desired packages folder content to your wpkg.js folder\packages
  ```
  git clone https://github.com/dbilanoski/wpkg-packages.git
  ```
* Adjust installation paths and variables in packages to your situation.

### Writing new packages
* Use templates from the .\Template folder as a starting point.

## References

* [WPKG Wiki page](https://wpkg.org/Main_Page)
* [Good XML Validator](https://www.liquid-technologies.com/online-xml-validator)
* [About REGEX Syntax](https://docs.microsoft.com/en-us/previous-versions/1400241x(v=vs.100)?redirectedfrom=MSDN)
* [About REGEX Syntax 2](https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference?redirectedfrom=MSDN)

## Help

Always use debugging to check the procedural execution of your setup.
* Best to have a debug script ready on your server.
* Best to have it directed to a textual file for readability.
  ```
  \\your-path-to-wpkg.js\wpkg.js /synchronize /debug > C:\wpkg-log.txt
  
  ```

## Authors

[Danilo Bilanoski](mailto:danilo.bilanoski@transcom.com)

## Acknowledgments

* [WPKG Silent Installers](https://wpkg.org/Category:Silent_Installers)

## ToDo
- [x] Initial draft, readme file
- [x] Templates for MSI and EXE both with and without IP validation
- [ ] Revise existing packages
