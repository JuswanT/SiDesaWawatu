#!/bin/bash
echo "====================================================="
echo "   DIAGNOSIS & PERBAIKAN TOTAL APPKEY"
echo "====================================================="

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}

echo ""
echo "========== LANGKAH 1: CEK DATABASE YANG ADA =========="
echo "Database yang terdaftar di MySQL:"
docker exec opensid-db mysql -uroot -p"$DB_PASS" -N -e "SHOW DATABASES LIKE 'opensid%';" 2>/dev/null
echo ""

echo "========== LANGKAH 2: CEK ISI database.php TIAP DESA =========="
for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "--- desa_$desa/config/database.php ---"
    if [ -f "desa_$desa/config/database.php" ]; then
        cat "desa_$desa/config/database.php"
    else
        echo "❌ FILE TIDAK ADA!"
    fi
    echo ""
done

echo "========== LANGKAH 3: CEK app_key FILE vs DATABASE =========="
for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "--- $desa ---"
    
    # AppKey dari FILE
    if [ -f "desa_$desa/app_key" ]; then
        FILE_KEY=$(cat "desa_$desa/app_key")
        echo "  FILE  app_key: $FILE_KEY"
    else
        echo "  FILE  app_key: ❌ TIDAK ADA"
    fi
    
    # AppKey dari DATABASE
    DB_KEY=$(docker exec opensid-db mysql -uroot -p"$DB_PASS" -N -e \
        "SELECT app_key FROM opensid_$desa.config LIMIT 1;" 2>/dev/null)
    if [ -n "$DB_KEY" ]; then
        echo "  DB    app_key: $DB_KEY"
    else
        echo "  DB    app_key: ❌ TIDAK BISA DIAMBIL (database/tabel belum ada?)"
    fi
    
    # Bandingkan
    if [ -n "$FILE_KEY" ] && [ -n "$DB_KEY" ]; then
        if [ "$FILE_KEY" = "$DB_KEY" ]; then
            echo "  STATUS: ✅ COCOK"
        else
            echo "  STATUS: ❌ TIDAK COCOK"
        fi
    fi
    echo ""
done

echo "========== LANGKAH 4: CEK APA YANG DIBACA CONTAINER =========="
for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "--- opensid-$desa ---"
    echo "  Isi /var/www/html/desa/app_key:"
    docker exec opensid-$desa cat /var/www/html/desa/app_key 2>/dev/null || echo "  ❌ TIDAK ADA"
    echo ""
    echo "  Isi /var/www/html/desa/config/database.php:"
    docker exec opensid-$desa cat /var/www/html/desa/config/database.php 2>/dev/null || echo "  ❌ TIDAK ADA"
    echo ""
    echo "  Folder desa_* di dalam container (folder hantu):"
    docker exec opensid-$desa ls -d /var/www/html/desa_* 2>/dev/null || echo "  (tidak ada - bagus!)"
    echo ""
done

echo "====================================================="
echo "   DIAGNOSIS SELESAI"
echo "====================================================="
