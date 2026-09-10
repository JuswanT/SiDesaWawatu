#!/bin/bash
echo "====================================================="
echo "   MEMPERBAIKI SEMUA ERROR (CSRF, 403 & SESSION)"
echo "====================================================="

# 1. Pastikan SQL ada
SQL_FILE="installer-master/install/sql/opensid.sql"
if [ ! -f "$SQL_FILE" ]; then
    echo "❌ Error: File $SQL_FILE masih tidak ditemukan! Pastikan Anda sudah git pull."
    exit 1
fi

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}

# 2. Suntik ulang database ke SEMUA desa (untuk memastikan)
echo "[1/3] Mengimpor ulang struktur database awal ke semua desa..."
for dbname in opensid_wawatu opensid_matawawatu opensid_tanjungtiram opensid_lalowaru; do
    cat "$SQL_FILE" | docker exec -i opensid-db mysql -u root -p"$DB_PASS" $dbname 2>/dev/null
    echo "      ✅ $dbname berhasil diimpor."
done

# 3. Perbaiki hak akses (Permission) agar session & csrf cookie bisa disimpan
echo "[2/3] Memperbaiki hak akses (permissions) folder..."
for desa in wawatu matawawatu tanjungtiram lalowaru; do
    # Wajib 777 agar www-data (Apache dalam docker) bisa menulis session
    chmod -R 777 "storage_${desa}" 2>/dev/null
    chmod -R 777 "desa_${desa}" 2>/dev/null
done

# Buat dummy favicon untuk mencegah ERR_TOO_MANY_REDIRECTS
touch favicon.ico

# 4. Restart container
echo "[3/3] Me-restart layanan..."
docker-compose restart

echo "====================================================="
echo "✅ PERBAIKAN SELESAI!"
echo "PENTING: Error 403 Forbidden (The action you have requested is not allowed)"
echo "terjadi karena browser Anda masih menyimpan 'Cookie/Session' usang dari"
echo "instalasi sebelumnya."
echo ""
echo "👉 SOLUSI: Buka web desa Anda melalui tab INCOGNITO (Private Browsing)"
echo "   atau HAPUS CACHE & COOKIE browser Anda sebelum mencoba login kembali."
echo "====================================================="
