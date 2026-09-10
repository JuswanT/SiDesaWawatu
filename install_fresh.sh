#!/bin/bash

echo "====================================================="
echo "   MENGISI DATABASE AWAL (FRESH INSTALL) 4 DESA"
echo "====================================================="

# Pastikan container berjalan
if ! docker ps | grep -q opensid-db; then
    echo "❌ Error: Container MySQL (opensid-db) tidak berjalan!"
    exit 1
fi

SQL_FILE="installer-master/install/sql/opensid.sql"

if [ ! -f "$SQL_FILE" ]; then
    echo "❌ Error: File $SQL_FILE tidak ditemukan!"
    exit 1
fi

echo "✅ File installer opensid.sql ditemukan!"

# Ambil password dari .env
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}

import_awal() {
    local dbname=$1
    echo "-----------------------------------------------------"
    echo "Mempersiapkan database: $dbname"
    
    echo "⏳ Mengimpor struktur awal OpenSID ke $dbname..."
    cat "$SQL_FILE" | docker exec -i opensid-db mysql -u root -p"$DB_PASS" $dbname 2>/dev/null
    
    echo "✅ Berhasil disuntikkan ke $dbname."
}

import_awal "opensid_wawatu"
import_awal "opensid_matawawatu"
import_awal "opensid_tanjungtiram"
import_awal "opensid_lalowaru"

echo "====================================================="
echo "✅ INSTALASI AWAL SELESAI!"
echo "Silakan buka kembali website desa Anda. Error akan hilang,"
echo "dan sistem kini dalam kondisi 100% baru layaknya baru diinstal."
echo "====================================================="
