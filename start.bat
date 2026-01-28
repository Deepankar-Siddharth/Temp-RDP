@echo off
REM ============================================
REM RDP Setup and Configuration Script
REM Automates Windows RDP environment setup
REM ============================================

setlocal enabledelayedexpansion
set ERROR_COUNT=0

REM Suppress command output for cleaner execution
set OUTPUT_FILE=out.txt

REM ============================================
REM System Configuration
REM ============================================

echo [*] Configuring system settings...

REM Remove Epic Games Launcher shortcut
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > %OUTPUT_FILE% 2>&1

REM Set server description
net config server /srvcomment:"Windows Server 2019" > %OUTPUT_FILE% 2>&1

REM Disable system tray auto-hide
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > %OUTPUT_FILE% 2>&1
if errorlevel 1 set /a ERROR_COUNT+=1

REM Configure autorun entries
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat > %OUTPUT_FILE% 2>&1
if errorlevel 1 set /a ERROR_COUNT+=1

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v autorun /t REG_SZ /d D:\a\autorun.bat > %OUTPUT_FILE% 2>&1
if errorlevel 1 set /a ERROR_COUNT+=1

REM ============================================
REM User Account Management
REM ============================================

echo [*] Creating user account...

REM Create new user with administrator privileges
net user Darkzino Qwerty@123456 /add >nul 2>&1
if errorlevel 1 (
    echo [!] Warning: User creation may have failed
    set /a ERROR_COUNT+=1
) else (
    echo [+] User created successfully
)

net localgroup administrators Darkzino /add >nul 2>&1
if errorlevel 1 set /a ERROR_COUNT+=1

net user Darkzino /active:yes >nul 2>&1
if errorlevel 1 set /a ERROR_COUNT+=1

REM Remove default installer user
net user installer /delete >nul 2>&1

REM ============================================
REM System Services and Permissions
REM ============================================

echo [*] Configuring system services...

REM Enable disk performance counters
diskperf -Y >nul 2>&1

REM Configure and start audio service
sc config Audiosrv start= auto >nul 2>&1
sc start audiosrv >nul 2>&1

REM Grant permissions to user
ICACLS C:\Windows\Temp /grant Darkzino:F >nul 2>&1
ICACLS C:\Windows\installer /grant Darkzino:F >nul 2>&1

REM ============================================
REM RDP Connection Information
REM ============================================

echo.
echo ============================================
echo RDP Setup Complete!
echo ============================================
echo.

if %ERROR_COUNT% GTR 0 (
    echo [!] Completed with %ERROR_COUNT% warning(s)
) else (
    echo [+] All configurations applied successfully
)

echo.
echo If the RDP is not accessible, please rebuild the workflow.
echo.
echo ============================================
echo RDP Connection Details:
echo ============================================
echo.

REM Attempt to retrieve ngrok tunnel information
echo [*] Retrieving ngrok tunnel information...
tasklist | find /i "ngrok.exe" >Nul 2>&1
if errorlevel 1 (
    echo [!] Unable to get NGROK tunnel
    echo [!] Please verify NGROK_AUTH is correct in Settings ^> Secrets ^> Repository secret
    echo [!] Check if previous VM is still running: https://dashboard.ngrok.com/status/tunnels
) else (
    REM Try to get ngrok tunnel URL using curl and jq
    for /f "tokens=*" %%i in ('curl -s localhost:4040/api/tunnels 2^>nul ^| jq -r .tunnels[0].public_url 2^>nul') do set NGROK_URL=%%i
    
    if defined NGROK_URL (
        echo IP: %NGROK_URL%
    ) else (
        echo IP: [Retrieving from ngrok...]
        echo [!] If IP is not shown, check ngrok dashboard: https://dashboard.ngrok.com/status/tunnels
    )
)

echo Username: Darkzino
echo Password: Qwerty@123456
echo.
echo ============================================
echo Please login to your RDP now!
echo ============================================
echo.

REM Brief pause before continuing
ping -n 10 127.0.0.1 >nul

endlocal
