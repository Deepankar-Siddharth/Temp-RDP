# 🖥️ Temp-RDP - Automated Windows RDP Provisioning

![header](https://capsule-render.vercel.app/api?type=waving&color=gradient&height=240&section=header&text=Temp-RDP&fontSize=44&fontAlignY=35)

<p align="center">
  <img src="https://img.shields.io/badge/Windows-RDP-blue?logo=windows" />
  <img src="https://img.shields.io/badge/GitHub-Actions-black?logo=github" />
  <img src="https://img.shields.io/badge/ngrok-Tunnel-1F1E37?logo=ngrok" />
  <img src="https://img.shields.io/badge/Automation-Script-green" />
</p>

---

## 📋 Overview

**Temp-RDP** is an automated Windows RDP (Remote Desktop Protocol) provisioning system that creates ephemeral Windows environments through GitHub Actions. The system automatically configures Windows Server instances, sets up secure ngrok tunneling, and provides instant remote desktop access for development, testing, and educational purposes.

### ✨ Key Features

- 🚀 **One-Click Provisioning** - Launch Windows RDP instances via GitHub Actions
- 🔒 **Secure Tunneling** - Automatic ngrok TCP tunnel setup for secure remote access
- ⚙️ **Automated Configuration** - Complete Windows environment setup with user accounts and system settings
- 📊 **Status Monitoring** - Real-time RDP and ngrok tunnel health monitoring
- 🎨 **Custom Wallpaper** - Automated wallpaper and system customization
- ⏱️ **Long-Running Sessions** - Up to 9999 minutes of runtime per instance

---

## 📁 Repository Structure

```
readme/
├── .github/
│   └── workflows/
│       └── blank.yml          # GitHub Actions workflow for RDP provisioning
├── start.bat                   # RDP setup and configuration script
├── loop.bat                    # RDP status monitoring script
├── wallpaper.bat               # Wallpaper and system configuration script
└── README.md                   # This file
```

---

## 🔧 Scripts Documentation

### 1. `start.bat` - RDP Setup and Configuration

**Purpose:** Automates complete Windows RDP environment setup and configuration.

**Functions:**
- ✅ **System Configuration**
  - Removes default desktop shortcuts (Epic Games Launcher)
  - Sets server description to "Windows Server 2019"
  - Disables system tray auto-hide
  - Configures autorun entries for wallpaper and system scripts

- 👤 **User Account Management**
  - Creates user account: `Darkzino`
  - Sets password: `Qwerty@123456`
  - Grants administrator privileges
  - Activates user account
  - Removes default installer user

- ⚙️ **System Services**
  - Enables disk performance counters
  - Configures and starts audio service
  - Grants file permissions to user account

- 🔗 **RDP Connection Info**
  - Retrieves ngrok tunnel URL via localhost:4040 API
  - Displays connection credentials
  - Provides troubleshooting information

**Usage:** Executed automatically by GitHub Actions workflow during RDP initialization.

---

### 2. `loop.bat` - RDP Status Monitor

**Purpose:** Continuously monitors RDP connection and ngrok tunnel status.

**Functions:**
- 🔍 **Process Monitoring**
  - Checks if `ngrok.exe` process is running
  - Validates RDP connection health
  - Displays real-time status with timestamp

- ⚠️ **Error Detection**
  - Detects ngrok process termination
  - Provides troubleshooting steps for connection issues
  - Validates ngrok authentication token

- 📊 **Status Display**
  - Shows current date and time (UTC)
  - Displays ngrok tunnel status
  - Provides connection health indicators

**Usage:** Runs continuously after RDP setup to monitor connection status. Press `Ctrl+C` to stop.

**Troubleshooting:**
- If ngrok process not found, check:
  1. NGROK_AUTH in GitHub Secrets
  2. Previous VM instance status
  3. ngrok dashboard: https://dashboard.ngrok.com/status/tunnels

---

### 3. `wallpaper.bat` - Wallpaper and System Configuration

**Purpose:** Sets system wallpaper and executes PowerShell configuration scripts.

**Functions:**
- 🔐 **Privilege Elevation**
  - Automatically requests administrator privileges via UAC
  - Creates temporary VBScript for elevation
  - Cleans up elevation scripts after execution

- 🎨 **Wallpaper Configuration**
  - Sets wallpaper from `C:\Windows\System32\wallpaper.bmp`
  - Updates registry entries for wallpaper
  - Forces wallpaper refresh via Windows API

- 📜 **PowerShell Script Execution**
  - Executes `system23.ps1` (system configuration)
  - Executes `autorun.ps1` (autorun tasks)
  - Uses RemoteSigned execution policy
  - Handles missing script files gracefully

- 🧹 **System Cleanup**
  - Removes desktop shortcuts (`.ink` and `.lnk` files)
  - Restarts Windows Explorer to apply changes
  - Restores original directory context

**Usage:** Executed automatically on system startup via autorun registry entry.

---

## 🚀 GitHub Actions Workflow

### Workflow: `blank.yml`

**Trigger:** Manual workflow dispatch via GitHub Actions UI

**Runtime:** Up to 9999 minutes (166.65 hours)

**Steps:**

1. **Download Required Files**
   - Downloads ngrok stable Windows binary
   - Downloads PowerShell scripts (`autorun.ps1`, `system23.ps1`)
   - Downloads batch scripts (`start.bat`, `wallpaper.bat`, `loop.bat`)
   - Downloads wallpaper image (`wallpaper.bmp`)

2. **Extract Ngrok Archive**
   - Extracts ngrok to `.\ngrok` directory

3. **Authenticate Ngrok Account**
   - Authenticates using `NGROK_AUTH` secret from repository settings
   - Validates authentication token

4. **Configure Remote Desktop Access**
   - Enables RDP via registry (`fDenyTSConnections = 0`)
   - Enables RDP firewall rules
   - Configures RDP authentication settings

5. **Deploy Configuration Files**
   - Copies `wallpaper.bat` to `D:\a\wallpaper.bat`
   - Copies `wallpaper.bmp` to `C:\Windows\System32\wallpaper.bmp`
   - Copies PowerShell scripts to `C:\Windows\System32\`

6. **Start Ngrok TCP Tunnel**
   - Starts ngrok tunnel on port 3389 (RDP default port)
   - Uses Asia Pacific (ap) region
   - Runs in background PowerShell process

7. **Initialize RDP Environment**
   - Executes `start.bat` to configure system
   - Creates user accounts and applies settings
   - Displays connection information

8. **Monitor RDP Status**
   - Executes `loop.bat` for continuous monitoring
   - Maintains RDP session active

---

## 🛠️ Setup Instructions

### Prerequisites

- GitHub account
- ngrok account (free tier available)
- Repository with GitHub Actions enabled

### Step-by-Step Setup

1. **Fork or Clone Repository**
   ```bash
   git clone https://github.com/Deepankar-Siddharth/readme.git
   ```

2. **Get ngrok Authentication Token**
   - Sign up at [ngrok Dashboard](https://dashboard.ngrok.com)
   - Navigate to [Auth Token](https://dashboard.ngrok.com/get-started/your-authtoken)
   - Copy your authentication token

3. **Configure GitHub Secrets**
   - Go to repository `Settings` → `Secrets and variables` → `Actions`
   - Click `New repository secret`
   - Name: `NGROK_AUTH`
   - Value: Paste your ngrok authentication token
   - Click `Add secret`

4. **Launch RDP Instance**
   - Navigate to `Actions` tab in repository
   - Select `Temp-RDP` workflow
   - Click `Run workflow` → `Run workflow` button
   - Wait for workflow to complete initialization

5. **Retrieve Connection Details**

   **Method 1: From Workflow Output (If Available)**
   - In the workflow run, expand `Initialize RDP Environment` step
   - Look for "RDP Connection Details" section
   - Copy the ngrok tunnel URL if displayed
   
   **Method 2: From ngrok Dashboard (Recommended)**
   - If workflow shows "Unable to get NGROK tunnel" error, use this method
   - Visit: https://dashboard.ngrok.com/status/tunnels
   - Find the active TCP tunnel on port 3389
   - Copy the public URL (format: `tcp://0.tcp.ap.ngrok.io:XXXXX`)
   - For RDP connection, use: `0.tcp.ap.ngrok.io:XXXXX` (remove `tcp://` prefix)
   
   **Default Credentials:**
   - **Username:** `Darkzino`
   - **Password:** `Qwerty@123456`

6. **Connect to RDP**
   - Open Remote Desktop Connection (mstsc.exe)
   - Enter the ngrok tunnel URL as the computer name
   - Use the provided username and password
   - Click Connect

---

## 📊 Connection Information

### Default Credentials

- **Username:** `Darkzino`
- **Password:** `Qwerty@123456`

### Port Information

- **RDP Port:** `3389` (standard Windows RDP port)
- **ngrok Tunnel:** TCP tunnel on port 3389
- **ngrok Region:** Asia Pacific (ap)

### Retrieving Connection URL

The ngrok tunnel URL is automatically retrieved during setup. If you see the error message:

```
[!] Unable to get NGROK tunnel
[!] Please verify NGROK_AUTH is correct in Settings > Secrets > Repository secret
[!] Check if previous VM is still running: https://dashboard.ngrok.com/status/tunnels
```

**Follow these steps:**

1. **Check ngrok Dashboard** (Primary Method)
   - Visit: https://dashboard.ngrok.com/status/tunnels
   - Look for active TCP tunnel on port 3389
   - Copy the public URL (format: `tcp://0.tcp.ap.ngrok.io:XXXXX`)
   - Remove the `tcp://` prefix and use only the hostname and port (e.g., `0.tcp.ap.ngrok.io:12345`)

2. **Verify GitHub Secrets**
   - Go to repository `Settings` → `Secrets and variables` → `Actions`
   - Verify `NGROK_AUTH` secret exists and is correct
   - If missing or incorrect, update it with your ngrok auth token

3. **Check for Active Tunnels**
   - If multiple tunnels exist, identify the one on port 3389
   - Ensure no previous VM instance is still running
   - Terminate old tunnels if necessary

4. **Manual Connection Format**
   - Use the format: `HOSTNAME:PORT` (e.g., `0.tcp.ap.ngrok.io:12345`)
   - Do NOT include `tcp://` prefix in Remote Desktop Connection
   - Enter in Remote Desktop Connection as: `0.tcp.ap.ngrok.io:12345`

---

## 🔍 Troubleshooting

### Issue: Unable to Get NGROK Tunnel

**Symptoms:**
- Error message: `[!] Unable to get NGROK tunnel`
- `start.bat` cannot retrieve ngrok tunnel information
- Connection URL not displayed in workflow output

**Solutions:**

1. **Check ngrok Dashboard** (Most Reliable Method)
   ```
   Visit: https://dashboard.ngrok.com/status/tunnels
   ```
   - Look for active TCP tunnel on port 3389
   - Copy the public URL shown
   - Format: `tcp://0.tcp.ap.ngrok.io:XXXXX`
   - For RDP connection, use: `0.tcp.ap.ngrok.io:XXXXX` (remove `tcp://`)

2. **Verify GitHub Secret**
   - Go to: `Settings` → `Secrets and variables` → `Actions`
   - Check if `NGROK_AUTH` secret exists
   - Verify the token is correct (no extra spaces or characters)
   - Get your token from: https://dashboard.ngrok.com/get-started/your-authtoken
   - Update the secret if incorrect

3. **Check for Multiple/Stale Tunnels**
   - Visit ngrok dashboard: https://dashboard.ngrok.com/status/tunnels
   - Terminate any old/stale tunnels
   - Ensure only one active tunnel exists for port 3389
   - Wait 1-2 minutes after starting workflow before checking

4. **Manual Retrieval Method**
   - Even if automatic retrieval fails, the tunnel is still active
   - Always check ngrok dashboard for the connection URL
   - The RDP instance is functional even if URL retrieval fails

5. **Rebuild Workflow**
   - If issues persist, cancel current workflow run
   - Verify `NGROK_AUTH` secret is correct
   - Start a new workflow run
   - Check dashboard immediately after tunnel starts

### Issue: ngrok Process Not Found

**Symptoms:**
- `loop.bat` shows "ngrok.exe process not found"
- RDP connection fails
- ngrok tunnel not established

**Solutions:**
1. Verify `NGROK_AUTH` secret is correctly set in repository settings
2. Check if previous VM instance is still running
3. Verify ngrok token at: https://dashboard.ngrok.com/status/tunnels
4. Check workflow logs for ngrok authentication errors
5. Rebuild the workflow if issues persist

### Issue: RDP Connection Timeout

**Symptoms:**
- Cannot connect to RDP using ngrok URL
- Connection times out

**Solutions:**
1. Verify ngrok tunnel is active in dashboard
2. Check if firewall is blocking connection
3. Ensure RDP is enabled on Windows instance
4. Try rebuilding the workflow

### Issue: User Account Not Created

**Symptoms:**
- Cannot login with provided credentials
- User account missing

**Solutions:**
1. Check `start.bat` execution logs in workflow
2. Verify user creation step completed successfully
3. Rebuild workflow if user creation failed
4. Check for error messages in workflow output

### Issue: Wallpaper Not Applied

**Symptoms:**
- Default wallpaper still showing
- Custom wallpaper not visible

**Solutions:**
1. Verify `wallpaper.bmp` was downloaded successfully
2. Check if `wallpaper.bat` executed without errors
3. Verify file exists at `C:\Windows\System32\wallpaper.bmp`
4. Restart Windows Explorer manually if needed

---

## ⚠️ Important Notes

### Security Considerations

- **Default Credentials:** The default username and password are hardcoded. Change them for production use.
- **ngrok Tunneling:** ngrok tunnels are publicly accessible. Use strong passwords.
- **Session Duration:** Workflows run for up to 9999 minutes. Monitor usage to avoid exceeding limits.

### Usage Guidelines

- ✅ **Intended Use:**
  - Development and testing environments
  - Educational purposes
  - Temporary remote access needs
  - Software testing and validation

- ❌ **Not Intended For:**
  - Production workloads
  - Cryptocurrency mining
  - Illegal activities
  - Unauthorized access attempts

### GitHub Actions Limits

- **Free Tier:** 2000 minutes/month
- **Workflow Timeout:** 9999 minutes per run
- **Concurrent Jobs:** Limited by GitHub plan

---

## 📝 Technical Details

### System Requirements

- **OS:** Windows Server 2019/2022 (GitHub Actions `windows-latest`)
- **RAM:** 7GB (GitHub Actions standard)
- **CPU:** 2 cores (GitHub Actions standard)
- **Storage:** 256GB SSD (GitHub Actions standard)

### Dependencies

- **ngrok:** Latest stable Windows binary
- **PowerShell:** Built-in Windows PowerShell
- **curl & jq:** For ngrok API interaction (optional)

### Registry Modifications

The scripts modify the following registry keys:

- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\EnableAutoTray`
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Wallpaper`
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\autorun`
- `HKEY_CURRENT_USER\Control Panel\Desktop\WallPaper`
- `HKLM:\System\CurrentControlSet\Control\Terminal Server\fDenyTSConnections`
- `HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\UserAuthentication`

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Areas for Contribution

- Enhanced error handling
- Additional system configurations
- Security improvements
- Documentation updates
- Feature requests

---

## 📄 License

This project is provided as-is for educational and development purposes.

---

## 🔗 Related Projects

- [Temp-RDP](https://github.com/Deepankar-Siddharth/Temp-RDP) - Main RDP provisioning repository
- [netslutter-RDP](https://github.com/Deepankar-Siddharth/netslutter-RDP) - Alternative RDP solution

---

## 📞 Support

For issues, questions, or contributions:

- **GitHub Issues:** Open an issue in this repository
- **Telegram:** [@darkzino](https://t.me/darkzino)
- **Email:** Deepankarab12@email.com

---

<div align="center">

**Built with ❤️ for automation enthusiasts**

*"Precision in automation. Reliability in execution."*

![footer](https://capsule-render.vercel.app/api?type=waving&color=gradient&height=120&section=footer)

</div>
