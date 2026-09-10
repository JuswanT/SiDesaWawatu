#!/bin/bash

echo "====================================================="
echo "   MENGATUR PEMISAHAN SISTEM (SINGLE TENANT)"
echo "====================================================="

# Pastikan berada di root direktori OpenSID
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: Jalankan script ini dari folder root SiDesaWawatu (yang berisi docker-compose.yml)."
    exit 1
fi

# Fungsi untuk setup storage masing-masing desa
setup_storage() {
    local desa=$1
    if [ ! -d "storage_$desa" ]; then
        echo "Membuat storage_$desa..."
        # Copy isi default storage
        if [ -d "storage" ]; then
            cp -a storage "storage_$desa"
        else
            mkdir -p "storage_$desa"
        fi
        
        # Bersihkan log dan cache bekas
        rm -rf "storage_$desa/framework/cache/data/*" 2>/dev/null
        rm -rf "storage_$desa/logs/*" 2>/dev/null
        
        # Beri izin tulis untuk docker
        chmod -R 777 "storage_$desa"
        echo "✅ storage_$desa berhasil dibuat."
    else
        echo "✅ storage_$desa sudah ada."
        # Bersihkan log dan cache bekas
        rm -rf "storage_$desa/framework/cache/data/*" 2>/dev/null
        rm -rf "storage_$desa/logs/*" 2>/dev/null
        chmod -R 777 "storage_$desa"
    fi
}

echo "1. Mempersiapkan folder storage dan backup..."
setup_storage "wawatu"
setup_storage "tanjungtiram"
setup_storage "lalowaru"
setup_storage "matawawatu"

# Pastikan folder desa ada
for desa in wawatu tanjungtiram lalowaru matawawatu; do
    if [ ! -d "desa_$desa" ]; then
        echo "⚠️  Peringatan: Folder desa_$desa belum ada. Silakan buat atau salin dari instalasi sebelumnya jika diperlukan."
    fi
done

echo ""
echo "2. Mematikan sistem yang lama..."
docker compose down

echo ""
echo "3. Menjalankan sistem yang baru dengan 4 container..."
docker compose up -d

echo ""
echo "====================================================="
echo "SELESAI! Sistem berhasil dipisahkan."
echo "Berikut adalah port akses masing-masing desa:"
echo "- Wawatu        : Port 6000"
echo "- Tanjung Tiram : Port 6001"
echo "- Lalowaru      : Port 6002"
echo "- Mata Wawatu   : Port 6003"
echo "====================================================="
echo "MOHON DIBACA:"
echo "Jangan lupa mengedit konfigurasi Proxy (Nginx/Laragon) Anda agar"
echo "desatanjungtiram.web.id diarahkan ke localhost:6001, dst."
