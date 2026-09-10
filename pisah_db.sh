#!/bin/bash

echo "====================================================="
echo "   MENDUPLIKASI DAN MEMISAHKAN DATABASE DESA"
echo "====================================================="

# Pastikan container database berjalan
if ! docker ps | grep -q opensid-db; then
    echo "❌ Error: Container MySQL (opensid-db) tidak sedang berjalan!"
    echo "Harap jalankan 'docker-compose up -d db' terlebih dahulu."
    exit 1
fi

# Mengambil konfigurasi dari file .env
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}
DB_NAME=${DB_DATABASE:-opensid}

echo "[1/3] Mengekspor data master dari database '$DB_NAME'..."
docker exec opensid-db mysqldump -u root -p"$DB_PASS" "$DB_NAME" > opensid_master.sql

if [ ! -s opensid_master.sql ]; then
    echo "❌ Error: Gagal mengekspor database."
    echo "Cek isi file .env Anda. Pastikan DB_ROOT_PASSWORD ($DB_PASS) dan DB_DATABASE ($DB_NAME) sudah benar."
    rm -f opensid_master.sql
    exit 1
fi

buat_db() {
    local dbname=$1
    echo "-----------------------------------------------------"
    echo "Mempersiapkan database: $dbname"
    
    # Buat database jika belum ada
    docker exec opensid-db mysql -u root -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS $dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" 2>/dev/null
    
    # Impor data master ke database baru
    cat opensid_master.sql | docker exec -i opensid-db mysql -u root -p"$DB_PASS" $dbname 2>/dev/null
    
    echo "✅ Berhasil disalin ke $dbname."
}

echo ""
echo "[2/3] Menyalin data ke masing-masing database desa..."
buat_db "opensid_wawatu"
buat_db "opensid_matawawatu"
buat_db "opensid_tanjungtiram"
buat_db "opensid_lalowaru"

echo ""
echo "[3/3] Membersihkan file sementara..."
rm -f opensid_master.sql

echo "====================================================="
echo "✅ SELESAI! Database telah sukses dipisahkan."
echo "Sekarang Anda bisa menjalankan 'bash fix_semua.sh'."
echo "====================================================="
