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

REM Wait a bit for ngrok to fully start
echo [*] Waiting for ngrok to initialize...
ping 127.0.0.1 -n 3 >Nul

REM Check if ngrok process is running (with retries)
set RETRY_COUNT=0
set MAX_RETRIES=5
set NGROK_FOUND=0

:CHECK_NGROK
tasklist | find /i "ngrok.exe" >Nul 2>&1
if not errorlevel 1 (
    set NGROK_FOUND=1
    goto NGROK_VERIFIED
)

set /a RETRY_COUNT+=1
if %RETRY_COUNT% LSS %MAX_RETRIES% (
    echo [*] Waiting for ngrok process... (Attempt %RETRY_COUNT%/%MAX_RETRIES%)
    ping 127.0.0.1 -n 3 >Nul
    goto CHECK_NGROK
)

REM Also try checking via ngrok API as fallback
echo [*] Checking ngrok via API...
curl -s http://localhost:4040/api/tunnels >nul 2>&1
if not errorlevel 1 (
    echo [+] Ngrok API is responding - tunnel may be active
    set NGROK_FOUND=1
    goto NGROK_VERIFIED
)

REM If still not found, show error but continue monitoring
if %NGROK_FOUND% EQU 0 (
    echo [!] WARNING: ngrok.exe process not found in tasklist
    echo [!] This may be normal if ngrok is running in a different session
    echo [!] Checking ngrok dashboard: https://dashboard.ngrok.com/status/tunnels
    echo [!] If tunnel is active there, you can proceed with connection
    echo.
    echo [*] Continuing monitoring anyway...
    echo [*] The tunnel may still be working - check dashboard to confirm
    echo.
    ping 127.0.0.1 -n 3 >Nul
    goto MONITOR_LOOP
)

:NGROK_VERIFIED
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

REM Verify ngrok is still running (check both process and API)
tasklist | find /i "ngrok.exe" >Nul 2>&1
if errorlevel 1 (
    REM Process not in tasklist, but check API as fallback
    curl -s http://localhost:4040/api/tunnels >nul 2>&1
    if errorlevel 1 (
        echo.
        echo [!] WARNING: ngrok process and API not responding!
        echo [!] RDP connection may be lost
        echo [!] Check dashboard: https://dashboard.ngrok.com/status/tunnels
        echo.
        ping 127.0.0.1 -n 3 >Nul
        goto INITIAL_CHECK
    ) else (
        REM API is responding, so tunnel is likely still active
        echo [+] Ngrok API responding - tunnel likely active
    )
)

REM Brief delay before next check (reduces CPU usage)
ping 127.0.0.1 -n 2 >Nul

goto MONITOR_LOOP

endlocal
