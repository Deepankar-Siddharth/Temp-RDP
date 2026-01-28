# 🖥️ Temp-RDP - Automated Windows RDP Provisioning

<p align="center">
  <img src="https://img.shields.io/badge/Windows-RDP-blue?logo=windows" />
  <img src="https://img.shields.io/badge/GitHub-Actions-black?logo=github" />
  <img src="https://img.shields.io/badge/ngrok-Tunnel-1F1E37?logo=ngrok" />
</p>

---

## Overview

**Temp-RDP** creates ephemeral Windows RDP environments via GitHub Actions with ngrok tunneling. One-click provisioning for development, testing, or education.

**Features:** One-click RDP via Actions • ngrok TCP tunnel • Automated user & system setup • Status monitoring • Custom wallpaper • Long sessions (up to 9999 min)

---

## Repository Structure

```
readme/
├── .github/workflows/blank.yml   # RDP workflow
├── start.bat                     # RDP setup & config
├── loop.bat                      # Status monitor
├── wallpaper.bat                 # Wallpaper & autorun
└── README.md
```

---

## Scripts (Brief)

| Script | Purpose |
|--------|--------|
| **start.bat** | System config, user creation (Darkzino / Qwerty@123456), services, RDP info from ngrok API. Run by workflow. |
| **loop.bat** | Monitors ngrok & RDP status. Run after setup; stop with Ctrl+C. |
| **wallpaper.bat** | Sets wallpaper, runs PowerShell scripts, cleanup. Runs on startup via autorun. |

---

## GitHub Actions Workflow (`blank.yml`)

- **Trigger:** Manual dispatch
- **Runtime:** Up to 9999 minutes
- **Steps:** Download ngrok & scripts → Extract → Auth with `NGROK_AUTH` → Enable RDP → Deploy files → Start ngrok TCP on 3389 → Run `start.bat` → Run `loop.bat`

---

## Setup

1. **Clone**
   ```bash
   git clone https://github.com/Deepankar-Siddharth/readme.git
   ```

2. **ngrok token** – Get from [ngrok Dashboard](https://dashboard.ngrok.com/get-started/your-authtoken).

3. **GitHub Secret** – In repo **Settings → Secrets and variables → Actions**, add:
   - Name: `NGROK_AUTH`
   - Value: your ngrok auth token

4. **Run** – **Actions** → **Temp-RDP** → **Run workflow**.

5. **Connect**
   - **URL:** From workflow output, or from [ngrok tunnels](https://dashboard.ngrok.com/status/tunnels) (TCP on 3389). Use `HOST:PORT` (e.g. `0.tcp.ap.ngrok.io:12345`) — no `tcp://`.
   - **User:** `Darkzino` • **Password:** `Qwerty@123456`

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| **Unable to get NGROK tunnel** | Get URL from [ngrok tunnels](https://dashboard.ngrok.com/status/tunnels); check `NGROK_AUTH` secret. |
| **ngrok process not found** | Verify `NGROK_AUTH`; check for another running VM/tunnel. |
| **RDP timeout** | Confirm tunnel is active; try rebuilding workflow. |
| **Login fails** | Check workflow logs for `start.bat`; rebuild if user creation failed. |

---

## Notes

- **Security:** Default credentials are hardcoded; change for any serious use. ngrok URL is public — use strong password.
- **Limits:** GitHub Actions free tier ~2000 min/month; workflow can run up to 9999 min per run.
- **Use for:** Dev/test, education. Not for production, mining, or abuse.

---

## Support

- **Issues:** Open an issue in this repo
- **Telegram:** [@darkzino](https://t.me/darkzino)
- **Email:** Deepankarab12@email.com

---

*Built for automation enthusiasts.*
