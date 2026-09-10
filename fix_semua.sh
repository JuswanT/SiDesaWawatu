#!/bin/bash

echo "====================================================="
echo "   SKRIP OTOMATIS PERBAIKAN 3 MASALAH OPENSID"
echo "====================================================="

# 1. Menarik pembaruan dari Github (Perbaikan index.php HTTPS Loop)
echo "[1/4] Menarik pembaruan kode perbaikan dari GitHub..."
git pull

# 2. Memperbaiki Konfigurasi Database yang "Nyangkut" di Wawatu
echo "[2/4] Memperbaiki koneksi database masing-masing desa..."

# Fungsi untuk mengganti nama database di config
fix_database() {
    local folder=$1
    local dbname=$2
    local db_file="$folder/config/database.php"
    
    if [ -f "$db_file" ]; then
        # Mengganti 'opensid_wawatu' atau 'opensid' menjadi nama database yang benar
        sed -i "s/'database'     => '.*'/'database'     => '$dbname'/g" "$db_file"
        echo "✅ Database $folder telah disetel ke: $dbname"
    else
        echo "⚠️  Peringatan: File $db_file tidak ditemukan!"
    fi
}

fix_database "desa_matawawatu" "opensid_matawawatu"
fix_database "desa_tanjungtiram" "opensid_tanjungtiram"
fix_database "desa_lalowaru" "opensid_lalowaru"
# Wawatu tetap
fix_database "desa_wawatu" "opensid_wawatu"

# 3. Membersihkan Sesi Lama & Cache (Penyebab 403 Forbidden & Tampilan Terhambur)
echo "[3/4] Membersihkan Cache dan Sesi bekas (Penyebab 403 & Tampilan berantakan)..."
for desa in wawatu matawawatu tanjungtiram lalowaru; do
    if [ -d "storage_$desa" ]; then
        rm -rf "storage_$desa/framework/sessions/"* 2>/dev/null
        rm -rf "storage_$desa/framework/views/"* 2>/dev/null
        rm -rf "storage_$desa/framework/cache/data/"* 2>/dev/null
        echo "✅ Cache & Session untuk $desa berhasil dibersihkan."
    fi
done

# 4. Melakukan Rebuild Container Docker
echo "[4/4] Membangun ulang dan me-restart Container Docker..."
docker-compose up -d --build

echo "====================================================="
echo "✅ SELESAI! Semua perbaikan telah diterapkan."
echo "Silakan Refresh (F5 / Ctrl+R) website di browser Anda."
echo "====================================================="
