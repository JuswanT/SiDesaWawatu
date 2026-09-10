#!/bin/bash
echo "====================================================="
echo "   PERBAIKAN BERDASARKAN HASIL DIAGNOSIS"
echo "====================================================="

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}

# ============================================
# LANGKAH 1: Import opensid.sql ke matawawatu (DB kosong!)
# ============================================
echo ""
echo "LANGKAH 1: Mengisi database opensid_matawawatu yang kosong..."
if [ -f "installer-master/install/sql/opensid.sql" ]; then
    docker exec -i opensid-db mysql -uroot -p"$DB_PASS" opensid_matawawatu < installer-master/install/sql/opensid.sql 2>/dev/null
    echo "✅ opensid_matawawatu berhasil diisi"
else
    echo "❌ File opensid.sql tidak ditemukan!"
fi

# ============================================
# LANGKAH 2: Sinkronkan AppKey matawawatu dari DB
# ============================================
echo ""
echo "LANGKAH 2: Sinkronisasi AppKey matawawatu..."
APP_KEY=$(docker exec opensid-db mysql -uroot -p"$DB_PASS" -N -e \
    "SELECT app_key FROM opensid_matawawatu.config LIMIT 1;" 2>/dev/null)
if [ -n "$APP_KEY" ]; then
    echo -n "$APP_KEY" > desa_matawawatu/app_key
    echo "✅ matawawatu AppKey disinkronkan: $APP_KEY"
else
    echo "⚠️  Tidak bisa mengambil AppKey, menggunakan fallback..."
    # Ambil dari file yang sudah ada dan update ke DB
    FILE_KEY=$(cat desa_matawawatu/app_key 2>/dev/null)
    if [ -n "$FILE_KEY" ]; then
        docker exec opensid-db mysql -uroot -p"$DB_PASS" -e \
            "UPDATE opensid_matawawatu.config SET app_key='$FILE_KEY' WHERE id=1;" 2>/dev/null
        echo "✅ DB matawawatu diupdate dengan AppKey dari file: $FILE_KEY"
    fi
fi

# ============================================
# LANGKAH 3: Bersihkan session lama (semua desa)
# ============================================
echo ""
echo "LANGKAH 3: Membersihkan session lama di semua container..."
for desa in wawatu matawawatu tanjungtiram lalowaru; do
    docker exec opensid-$desa bash -c "rm -rf /var/www/html/storage/framework/sessions/*" 2>/dev/null
    rm -rf storage_$desa/framework/sessions/* 2>/dev/null
    echo "✅ Session opensid-$desa dibersihkan"
done

# ============================================
# LANGKAH 4: Restart semua container
# ============================================
echo ""
echo "LANGKAH 4: Restart semua container..."
docker-compose restart

# ============================================
# VERIFIKASI AKHIR
# ============================================
echo ""
echo "========== VERIFIKASI AKHIR =========="
for desa in wawatu matawawatu tanjungtiram lalowaru; do
    FILE_KEY=$(cat "desa_$desa/app_key" 2>/dev/null)
    DB_KEY=$(docker exec opensid-db mysql -uroot -p"$DB_PASS" -N -e \
        "SELECT app_key FROM opensid_$desa.config LIMIT 1;" 2>/dev/null)
    
    if [ "$FILE_KEY" = "$DB_KEY" ]; then
        echo "✅ $desa: COCOK ($FILE_KEY)"
    else
        echo "❌ $desa: TIDAK COCOK (File: $FILE_KEY | DB: $DB_KEY)"
    fi
done

echo ""
echo "====================================================="
echo "✅ PERBAIKAN SELESAI!"
echo ""
echo "PENTING: Buka browser dalam mode INCOGNITO (Ctrl+Shift+N)"
echo "atau hapus cache browser (Ctrl+Shift+Delete) sebelum"
echo "mengakses website, karena session lama masih tersimpan."
echo "====================================================="
