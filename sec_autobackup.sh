#!/bin/bash

TOKEN="Bu yerga telegram bot bergan Tokendi joylashtirasiz"
CHAT_ID="Bu yerga shaxsiy telegram chat id sini joylaysiz"

GPG_PASSWORD="O'zingizga qulay bo'lgan parol yozasiz"

send_message() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message" \
        -d parse_mode="Markdown"
}

SOURCE_DIR="/home/clay/Documents/Projects"
BACKUP_DIR="/home/clay/Backups"
LOG_FILE="$BACKUP_DIR/backup.log"
RETENTION_DAYS=3

NOW=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$NOW.tar.gz"
ENCRYPTED_FILE="$BACKUP_FILE.gpg"


if [ ! -d "$SOURCE_DIR" ]; then
    MSG="❌ *Xatolik*: manba papka topilmadi: \`$SOURCE_DIR\`"
    echo "[$NOW] $MSG" | tee -a "$LOG_FILE"
    send_message "$MSG"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "[$NOW] 🔄 Backup jarayoni boshlandi..." | tee -a "$LOG_FILE"
tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>>"$LOG_FILE"

if [ $? -eq 0 ]; then
    MSG="✅ *Backup tayyorlandi:* \`$BACKUP_FILE\`"
    echo "[$NOW] $MSG" | tee -a "$LOG_FILE"
    send_message "$MSG"
else
    MSG="❌ *Backupda xatolik yuz berdi!*"
    echo "[$NOW] $MSG" | tee -a "$LOG_FILE"
    send_message "$MSG"
    exit 1
fi

echo "[$NOW] 🔐 Backup shifrlanmoqda..." | tee -a "$LOG_FILE"
gpg --batch --yes --passphrase "$GPG_PASSWORD" -c "$BACKUP_FILE" 2>>"$LOG_FILE"

if [ $? -eq 0 ]; then
    MSG="🔐 *Backup shifrlab saqlandi:* \`$ENCRYPTED_FILE\`"
    echo "[$NOW] $MSG" | tee -a "$LOG_FILE"
    send_message "$MSG"
    rm "$BACKUP_FILE"  # Shifrlanmagan faylni o‘chiramiz
else
    MSG="❌ *GPG shifrlashda xatolik yuz berdi!*"
    echo "[$NOW] $MSG" | tee -a "$LOG_FILE"
    send_message "$MSG"
fi

echo "[$NOW] 🧹 $RETENTION_DAYS kundan eski backup’larni tozalash..." | tee -a "$LOG_FILE"
find "$BACKUP_DIR" -name "backup_*.tar.gz.gpg" -mtime +$RETENTION_DAYS -exec rm -f {} \; 2>>"$LOG_FILE"

echo "[$NOW] ✅ Tozalash yakunlandi." | tee -a "$LOG_FILE"
send_message "🧹 *Tozalash tugadi*. $RETENTION_DAYS kundan eski `.gpg` backup’lar o‘chirildi."

exit 0
