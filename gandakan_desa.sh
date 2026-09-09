#!/bin/bash

echo "Memulai proses penggandaan folder desa untuk multisite..."

# Pastikan folder desa asli (bawaan) ada
if [ ! -d "desa" ]; then
    echo "Error: Folder 'desa' tidak ditemukan di direktori saat ini."
    exit 1
fi

# Daftar desa yang akan dibuat
DESA_LIST=("desa_wawatu" "desa_matawawatu" "desa_tanjungtiram" "desa_lalowaru")

for desa in "${DESA_LIST[@]}"; do
    if [ ! -d "$desa" ]; then
        echo "Membuat folder $desa..."
        cp -r desa "$desa"
        
        # Set permission agar bisa diakses oleh web server/Docker
        chmod -R 775 "$desa"
        
        echo "Berhasil membuat $desa."
    else
        echo "Info: Folder $desa sudah ada, dilewati."
    fi
done

echo ""
echo "=== PENTING UNTUK DOCKER PENGGUNA ==="
echo "Jika Anda menggunakan Docker, pastikan Anda juga telah menambahkan"
echo "volume baru di dalam file docker-compose.yml seperti ini:"
echo "    volumes:"
echo "      - ./desa:/var/www/html/desa"
echo "      - ./desa_wawatu:/var/www/html/desa_wawatu"
echo "      - ./desa_matawawatu:/var/www/html/desa_matawawatu"
echo "      - ./desa_tanjungtiram:/var/www/html/desa_tanjungtiram"
echo "      - ./desa_lalowaru:/var/www/html/desa_lalowaru"
echo ""
echo "Setelah itu, jalankan: docker-compose up -d"
echo "====================================="
echo "Proses selesai!"
