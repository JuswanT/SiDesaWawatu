#!/bin/bash

echo "====================================================="
echo "   RESET TOTAL (FACTORY RESET) 4 DESA OPENSID"
echo "====================================================="
echo "Peringatan: Seluruh data akan dihapus..."

# Pastikan container berjalan
if ! docker ps | grep -q opensid-db; then
    echo "❌ Error: Container MySQL (opensid-db) tidak berjalan!"
    exit 1
fi

# Ambil password dari .env
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}

reset_desa() {
    local folder=$1
    local dbname=$2
    local storage_folder="storage_${folder#desa_}"

    echo "-----------------------------------------------------"
    echo "Mereset Desa: $folder (Database: $dbname)"

    # 1. Reset Database menjadi KOSONG
    echo "[1/4] Menghapus dan membuat ulang database..."
    docker exec opensid-db mysql -u root -p"$DB_PASS" -e "DROP DATABASE IF EXISTS $dbname; CREATE DATABASE $dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" 2>/dev/null

    # 2. Hapus seluruh isi folder desa tanpa terkecuali
    echo "[2/4] Menghapus aset, logo, dan pengaturan lama..."
    if [ -d "$folder" ]; then
        rm -rf "$folder"/*
    else
        mkdir -p "$folder"
    fi

    # 3. Buatkan kembali HANYA file koneksi agar database tetap TERPISAH
    echo "[3/4] Menautkan kembali ke database mandiri..."
    mkdir -p "$folder/config"
    cat <<EOF > "$folder/config/database.php"
<?php
\$db['default']['database'] = '$dbname';
EOF

    # 4. Hapus total cache & session
    echo "[4/4] Membersihkan Cache dan Sesi..."
    if [ -d "$storage_folder" ]; then
        rm -rf "$storage_folder/framework/sessions/"* 2>/dev/null
        rm -rf "$storage_folder/framework/views/"* 2>/dev/null
        rm -rf "$storage_folder/framework/cache/data/"* 2>/dev/null
    fi
    echo "✅ $folder bersih total!"
}

reset_desa "desa_wawatu" "opensid_wawatu"
reset_desa "desa_matawawatu" "opensid_matawawatu"
reset_desa "desa_tanjungtiram" "opensid_tanjungtiram"
reset_desa "desa_lalowaru" "opensid_lalowaru"

echo "====================================================="
echo "Restarting sistem agar membaca keadaan kosong..."
docker-compose restart

echo "====================================================="
echo "✅ RESET TOTAL SELESAI!"
echo "Silakan buka alamat website masing-masing desa Anda."
echo "Anda akan diarahkan ke halaman instalasi awal OpenSID."
echo "====================================================="
