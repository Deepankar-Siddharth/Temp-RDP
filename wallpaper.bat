@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Looking for Admin Access!
goto UACPrompt
) else ( goto Meet Admin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:Meet Admin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallPaper /t REG_SZ /d C:\Windows\System32\wallpaper.bmp /f
Powershell.exe -executionpolicy remotesigned -File C:\Windows\System32\system23.ps1 
Powershell.exe -executionpolicy remotesigned -File C:\Windows\System32\autorun.ps1 
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
del C:\Users\Darkzino\Desktop\*.ink
taskkill /f /im explorer.exe
start explorer.exe
