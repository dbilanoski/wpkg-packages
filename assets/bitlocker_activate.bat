@echo off

REM Check if BitLocker GPO is applied
REM Put your gpo name under GPO variable if you use it. If not, no harm as is or delete the whole block from gpreult to :startBitLocker

set GPO=your-bitlocker-gpo
gpresult /scope Computer /R | findstr /I "%GPO%"

if %errorlevel% == 0 (
    GOTO startBitlocker
) else (
    echo %COMPUTERNAME% exited with error %ERRORLEVEL%. GP %GPO% not found on computer - please move computer to BitLocker OU. >> C:\biLocker_log.txt
    Exit /B 501
)

:StartBitlocker
REM Check if BitLocker is already active

for /F "tokens=3 delims= " %%A in ('manage-bde -status %systemdrive% ^| findstr "    Encryption Method:"') do (
    if "%%A"=="AES" goto EncryptionCompleted
    )

for /F "tokens=3 delims= " %%A in ('manage-bde -status %systemdrive% ^| findstr "    Encryption Method:"') do (
    if "%%A"=="XTS-AES" goto EncryptionCompleted
    )

for /F "tokens=3 delims= " %%A in ('manage-bde -status %systemdrive% ^| findstr "    Encryption Method:"') do (
    if "%%A"=="None" goto BitLock
    )


:Bitlock
REM Activate BitLocker

manage-bde -protectors -add %systemdrive% -RecoveryPassword || GOTO ErrorHandler
manage-bde -protectors -enable %systemdrive% || GOTO ErrorHandler
manage-bde -on %systemdrive% -SkipHardwareTest || GOTO ErrorHandler
GOTO EncryptionCompleted


:ErrorHandler

echo %COMPUTERNAME% exited with error %ERRORLEVEL%. Please check your System, TPM and BIOS settings. >> C:\biLocker_log.txt
Exit /B 501

:EncryptionCompleted

echo %COMPUTERNAME% - Operation successfull >> C:\biLocker_log.txt
Exit /B 500