# 🛡️ Auto Backup Tool (Linux Telegram-Integrated Script)

This is a fully automated, secure Linux-based backup tool written in Bash. It compresses and encrypts project folders, sends real-time alerts to Telegram, and removes outdated backup files. It also supports future integration with cloud storage and configuration files.

---

## ✨ Features

- 📦 Compresses a selected folder into `.tar.gz`
- 🔐 Encrypts the archive using **GPG symmetric encryption**
- 📬 Sends real-time alerts via **Telegram bot**
- 🧹 Deletes backups older than a specified number of days
- 🗂️ Logs all actions in `backup.log`

---

## ⚙️ Requirements

- Bash 4.x+
- `curl` – for Telegram API requests
- `gpg` – for encryption

Install on Ubuntu/Debian:

```bash
sudo apt update
sudo apt install curl gnupg -y
```

---

## 🤖 Telegram Setup

### 1. Create a Telegram bot
- Go to [@BotFather](https://t.me/BotFather)
- Send `/newbot`
- Choose a name and a unique username ending in `bot`
- Copy the **API token** it gives you

### 2. Get your chat ID
- Go to [@userinfobot](https://t.me/userinfobot)
- Send `/start`
- It replies with `Your ID: 123456789`

---

## 🔐 How Encryption Works

The tool uses GPG's `--symmetric` mode to encrypt the `.tar.gz` file with a passphrase. Decryption requires the same password.

---

## 🚀 How to Use

### 1. Clone the repository

```bash
git clone https://github.com/AliTojiboyev/auto-backup-tool.git
cd auto-backup-tool
```

### 2. Make the script executable

```bash
chmod +x sec_autobackup.sh
```

### 3. Run the script

```bash
./sec_autobackup.sh
```

You'll be prompted to enter:
- Telegram Bot Token
- Chat ID
- GPG Password (hidden)

Backup will be saved to `~/Backups/`, Telegram will notify, and backups older than 3 days will be deleted.

---

## 🔓 How to Decrypt Backups

```bash
gpg --output my_backup.tar.gz --decrypt backup_*.tar.gz.gpg
tar -xzf my_backup.tar.gz
```

---

## 🔧 Configuration (planned for `config.cfg` support)

Planned config file structure:

```ini
TOKEN=your_bot_token
CHAT_ID=your_chat_id
GPG_PASSWORD=your_passphrase
SOURCE_DIR=/path/to/source
BACKUP_DIR=/path/to/backups
RETENTION_DAYS=3
```

---

## 📜 License

MIT License — feel free to use, modify, and share.

---

## 👤 Author

**Ali Tojiboyev**  
[GitHub](https://github.com/AliTojiboyev) | [Telegram](https://t.me/alicodesvami)
