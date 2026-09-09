#!/bin/bash
# ============================================
# Script Pisahkan Database Multisite OpenSID
# ============================================

set -e

echo "=========================================="
echo "  Memisahkan Database untuk Multisite"
echo "=========================================="

echo "[0/4] Mengambil password root dari dalam container..."
# Ekstrak password langsung dari environment container MySQL
DB_PASS=$(docker exec opensid-db printenv MYSQL_ROOT_PASSWORD | tr -d '\r')

if [ -z "$DB_PASS" ]; then
    echo "Gagal menemukan MYSQL_ROOT_PASSWORD di dalam container. Menggunakan 'rahasia123' sebagai default."
    DB_PASS="rahasia123"
fi

echo "Password root berhasil ditemukan."

echo "[1/4] Mencadangkan (Dump) database utama 'opensid'..."
docker exec opensid-db bash -c "mysqldump -u root -p\"\$MYSQL_ROOT_PASSWORD\" opensid > /tmp/opensid_template.sql"

DESA_LIST=("desa_wawatu" "desa_matawawatu" "desa_tanjungtiram" "desa_lalowaru")

for DESA_DIR in "${DESA_LIST[@]}"; do
    # Buat nama database dari nama folder (misal: opensid_wawatu)
    DB_NAME="opensid_${DESA_DIR#desa_}"
    
    echo "------------------------------------------"
    echo "  Memproses: $DESA_DIR -> Database: $DB_NAME"
    echo "------------------------------------------"

    echo "  - Membuat database $DB_NAME di MySQL..."
    docker exec opensid-db bash -c "mysql -u root -p\"\$MYSQL_ROOT_PASSWORD\" -e \"CREATE DATABASE IF NOT EXISTS $DB_NAME;\""

    echo "  - Mengimpor data ke $DB_NAME..."
    docker exec opensid-db bash -c "mysql -u root -p\"\$MYSQL_ROOT_PASSWORD\" $DB_NAME < /tmp/opensid_template.sql"

    echo "  - Memberikan hak akses untuk user 'opensid' ke $DB_NAME..."
    docker exec opensid-db bash -c "mysql -u root -p\"\$MYSQL_ROOT_PASSWORD\" -e \"GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO 'opensid'@'%'; FLUSH PRIVILEGES;\""

    echo "  - Memperbarui config/database.php di folder $DESA_DIR..."
    if [ -f "$DESA_DIR/config/database.php" ]; then
        # Mengganti baris database dengan yang baru
        sed -i "s/\$db\['default'\]\['database'\].*/\$db['default']['database'] = '$DB_NAME';/g" "$DESA_DIR/config/database.php"
        echo "  - Config database.php berhasil diupdate."
    else
        echo "  - PERINGATAN: File $DESA_DIR/config/database.php tidak ditemukan!"
    fi
done

echo ""
echo "[4/4] Membersihkan file sementara..."
docker exec opensid-db rm /tmp/opensid_template.sql

echo ""
echo "=========================================="
echo "  ✅ PEMISAHAN DATABASE SELESAI!"
echo "=========================================="
echo "Sekarang pengaturan, data, dan artikel di masing-masing desa"
echo "sudah berdiri sendiri-sendiri dan tidak akan saling mempengaruhi."
echo "=========================================="
