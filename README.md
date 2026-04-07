# 🧪 Maverick - Reverse RDP via LNK Obfuscation

> **Educational purpose only | Simulated attack technique in isolated lab environment**

## 📌 Overview

This repository documents the **"Maverick" technique** – a method to establish a **reverse RDP/VNC connection** using a malicious LNK shortcut file disguised as an invoice, successfully bypassing Windows Defender through obfuscation.

## 🎯 Key techniques demonstrated

- ✅ Obfuscated LNK generation (Base64 + cmd `for` loop)
- ✅ Reverse VNC connection over port `5500`
- ✅ Phishing simulation (fake email + ZIP attachment)
- ✅ PowerShell payload auto-deployment
- ✅ Bypass Windows Defender (cleartext fails → obfuscated succeeds)

## 🖥️ Lab environment

| Role | OS | IP |
|------|----|----|
| Victim | Windows Server | `192.168.1.1` |
| Attacker / C2 | Windows Server | `192.168.1.2` |
- Web server: IIS (Attacker hosting)

## 📁 Repository structure
maverick/

├── deploy_ultravnc_noexit.ps1 # PowerShell payload (download + reverse connection)

├── LNKplaintext.txt # Cleartext LNK (failed)

├── LNKobfuscation.txt # Obfuscated LNK (successful)

└── DEMO MAVERICK.docx # Full Vietnamese report (step-by-step)
