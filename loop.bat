@echo off
REM ============================================
REM RDP Status Monitor
REM Continuously monitors RDP and ngrok tunnel status
REM ============================================

setlocal enabledelayedexpansion

:INITIAL_CHECK
cls
echo ============================================
echo RDP Status Monitor
echo ============================================
echo.

REM Check if ngrok process is running
tasklist | find /i "ngrok.exe" >Nul 2>&1
if errorlevel 1 (
    echo [!] ERROR: ngrok.exe process not found
    echo.
    echo Possible issues:
    echo   1. NGROK_AUTH_TOKEN may be incorrect
    echo   2. Check Settings ^> Secrets ^> Repository secret
    echo   3. Previous VM instance may still be running
    echo   4. Check ngrok status: https://dashboard.ngrok.com/status/tunnels
    echo.
    echo Waiting 5 seconds before exit...
    ping 127.0.0.1 -n 6 >Nul
    exit /b 1
)

echo [+] RDP Creation Successful!
echo [+] ngrok tunnel is active
echo.

:MONITOR_LOOP
REM Clear screen and display status
cls
echo ============================================
echo RDP Status Monitor
echo ============================================
echo.
echo [+] RDP WORKING @ %date% %time% UTC
echo [+] ngrok tunnel: ACTIVE
echo.
echo [*] Monitoring RDP connection...
echo [*] Press Ctrl+C to stop monitoring
echo.

REM Verify ngrok is still running
tasklist | find /i "ngrok.exe" >Nul 2>&1
if errorlevel 1 (
    echo.
    echo [!] WARNING: ngrok process terminated!
    echo [!] RDP connection may be lost
    echo.
    ping 127.0.0.1 -n 3 >Nul
    goto INITIAL_CHECK
)

REM Brief delay before next check (reduces CPU usage)
ping 127.0.0.1 -n 2 >Nul

goto MONITOR_LOOP

endlocal
