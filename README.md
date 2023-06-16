![Logo](logo.jpg)

# macOS Fixer eXtention for Fish-Shell

### This project contains solutions to fix problems in easiest way.

**This project is completely open source, and I just want to give simple fixes for hard problems.**
Any commits will be checked for security and added to the project.

---

### Fixes Library:

```
. macOS Fixer eXtention Library
├── App tools:
│   ├── discord - Show all devices in app.
│   ├── htop - Manage processes with sudo-user.
│   ├── winex - Wine X launcher (Patched Wine Crossover needed).
│   ├── xattr - the easy solution, if app dont launch by reasons.
│   └── msf - Add MSF support to fish 3.*
├── Update funcs:
│   └── update
│          ├── all - Update all
│          ├── self - Update self (macfx)
│          ├── fish - Update fish and completions via man
│          └── locate - Update locate DB
├── Services management:
│   ├── spell - SpellChk service
│   ├── airdrop - AirDrop enabler via eth0 (if available Bluetooth)
│   └── rdbug - restarts Remote Desktop services
└── System tools:
    ├── rtcsnd - Fix RTC on hackintosh systems. [cutted, in update]
    ├── tm - easy cleanup manager of Timeshift.
    ├── ip - get public IP.
    ├── mathfix - MKL Math fix for hackintosh systems.
    ├── setenv - Set Env variable.
    └── jenv - List and select Java Environment
```

---

### Installation

Just run the following command:

```bash
curl https://api.nekkit.xyz/macfx/app > ~/.config/fish/functions/macfx.fish && source
```
