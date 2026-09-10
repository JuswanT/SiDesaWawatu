#!/bin/bash

echo "====================================================="
echo "   RESTORASI DATABASE DARI BACKUP TERBARU"
echo "====================================================="

# Pastikan container database berjalan
if ! docker ps | grep -q opensid-db; then
    echo "❌ Error: Container MySQL (opensid-db) tidak sedang berjalan!"
    exit 1
fi

# Cari file SQL backup terbaru di direktori saat ini
BACKUP_FILE=$(find . -name "*.sql" -type f | grep "backup-desa" | sort -r | head -n 1)

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ Tidak ditemukan file backup (.sql) di direktori ini."
    exit 1
fi

echo "✅ File backup terbaru ditemukan: $BACKUP_FILE"

# Mengambil konfigurasi dari file .env
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}

restore_db() {
    local dbname=$1
    echo "-----------------------------------------------------"
    echo "Mempersiapkan database: $dbname"
    
    # Buat database jika belum ada
    docker exec opensid-db mysql -u root -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS $dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" 2>/dev/null
    
    echo "⏳ Mengimpor data ke $dbname... (Tunggu sebentar, ukuran file besar)"
    cat "$BACKUP_FILE" | docker exec -i opensid-db mysql -u root -p"$DB_PASS" $dbname 2>/dev/null
    
    echo "✅ Berhasil direstorasi ke $dbname."
}

restore_db "opensid_wawatu"
restore_db "opensid_matawawatu"
restore_db "opensid_tanjungtiram"
restore_db "opensid_lalowaru"

echo "====================================================="
echo "✅ SELESAI! Seluruh database berhasil dipulihkan."
echo "Silakan refresh website Anda."
echo "====================================================="
