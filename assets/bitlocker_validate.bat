@echo off

for /F "tokens=3 delims= " %%A in ('manage-bde -status %systemdrive% ^| findstr "    Encryption Method:"') do (
    if "%%A"=="AES" GOTO EncryptionActive
    )

for /F "tokens=3 delims= " %%A in ('manage-bde -status %systemdrive% ^| findstr "    Encryption Method:"') do (
    if "%%A"=="XTS-AES" GOTO EncryptionActive
    )

for /F "tokens=3 delims= " %%A in ('manage-bde -status %systemdrive% ^| findstr "    Encryption Method:"') do (
    if "%%A"=="None" GOTO EncryptionNotActive
    )

:EncryptionActive
exit /B 200

:EncryptionNotActive
exit /B 201