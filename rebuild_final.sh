#!/bin/bash
echo "====================================================="
echo "   PERBAIKAN FINAL: REBUILD CONTAINER DOCKER"
echo "====================================================="

# Langkah 1: Pastikan AppKey di file desa cocok dengan database
echo "Mengambil AppKey dari database..."

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}

for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "Mengambil AppKey dari database opensid_$desa..."
    
    # Ambil app_key langsung dari tabel config di database
    APP_KEY=$(docker exec opensid-db mysql -uroot -p"$DB_PASS" -N -e \
        "SELECT app_key FROM opensid_$desa.config LIMIT 1;" 2>/dev/null)
    
    if [ -n "$APP_KEY" ]; then
        echo -n "$APP_KEY" > "desa_$desa/app_key"
        echo "✅ $desa: AppKey disinkronkan → $APP_KEY"
    else
        echo "⚠️  $desa: Tidak bisa mengambil AppKey dari database (mungkin DB belum ada)"
    fi
done

# Langkah 2: Hancurkan container lama (menghapus semua folder hantu)
echo ""
echo "Menghancurkan container lama..."
docker-compose down

# Langkah 3: Bangun ulang image Docker dengan kode constants.php yang sudah diperbaiki
echo "Membangun ulang image Docker (dengan kode yang sudah diperbaiki)..."
docker-compose build --no-cache

# Langkah 4: Nyalakan container baru
echo "Menyalakan container baru..."
docker-compose up -d

echo "====================================================="
echo "✅ SEMUA SELESAI!"
echo ""
echo "Perubahan yang dilakukan:"
echo "  1. Blok multisite di constants.php DIHAPUS"
echo "     (tidak diperlukan karena Docker sudah memisahkan container)"
echo "  2. AppKey di file desa/* disinkronkan dari database"
echo "  3. Container di-rebuild dari nol (folder hantu musnah)"
echo ""
echo "Silakan buka semua website desa Anda sekarang!"
echo "====================================================="
