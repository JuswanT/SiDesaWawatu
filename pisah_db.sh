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

echo "[1/3] Mengekspor data master dari database 'opensid'..."
# Gunakan kredensial default dari .env (root / rahasia123)
docker exec opensid-db mysqldump -u root -prahasia123 opensid > opensid_master.sql 2>/dev/null

if [ ! -s opensid_master.sql ]; then
    echo "❌ Error: Gagal mengekspor database. Pastikan password root benar dan database 'opensid' masih ada."
    rm -f opensid_master.sql
    exit 1
fi

buat_db() {
    local dbname=$1
    echo "-----------------------------------------------------"
    echo "Mempersiapkan database: $dbname"
    
    # Buat database jika belum ada
    docker exec opensid-db mysql -u root -prahasia123 -e "CREATE DATABASE IF NOT EXISTS $dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" 2>/dev/null
    
    # Impor data master ke database baru
    cat opensid_master.sql | docker exec -i opensid-db mysql -u root -prahasia123 $dbname 2>/dev/null
    
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
