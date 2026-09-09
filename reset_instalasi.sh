#!/bin/bash
# ============================================
# Script Reset Database ke Mode Instalasi
# ============================================

set -e

echo "=========================================="
echo "  Reset Database untuk Instalasi Ulang"
echo "=========================================="

echo "[0/3] Mengambil password root dari dalam container..."
DB_PASS=$(docker exec opensid-db printenv MYSQL_ROOT_PASSWORD | tr -d '\r')

if [ -z "$DB_PASS" ]; then
    echo "Gagal menemukan MYSQL_ROOT_PASSWORD. Menggunakan 'rahasia123'."
    DB_PASS="rahasia123"
fi

DESA_LIST=("desa_wawatu" "desa_matawawatu" "desa_tanjungtiram" "desa_lalowaru")

for DESA_DIR in "${DESA_LIST[@]}"; do
    DB_NAME="opensid_${DESA_DIR#desa_}"
    
    echo "------------------------------------------"
    echo "  Mereset: $DESA_DIR (Database: $DB_NAME)"
    echo "------------------------------------------"

    echo "  - Menghapus database lama (jika ada)..."
    docker exec opensid-db bash -c "mysql -u root -p\"\$MYSQL_ROOT_PASSWORD\" -e \"DROP DATABASE IF EXISTS $DB_NAME;\""

    echo "  - Membuat ulang database kosong..."
    docker exec opensid-db bash -c "mysql -u root -p\"\$MYSQL_ROOT_PASSWORD\" -e \"CREATE DATABASE $DB_NAME;\""

    echo "  - Memberikan hak akses untuk user 'opensid'..."
    docker exec opensid-db bash -c "mysql -u root -p\"\$MYSQL_ROOT_PASSWORD\" -e \"GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO 'opensid'@'%'; FLUSH PRIVILEGES;\""

    echo "  - Menghapus file config/database.php agar memicu halaman Instalasi..."
    if [ -f "$DESA_DIR/config/database.php" ]; then
        rm "$DESA_DIR/config/database.php"
        echo "  - File config dihapus."
    else
        echo "  - File config sudah tidak ada."
    fi
done

echo ""
echo "=========================================="
echo "  ✅ RESET SELESAI!"
echo "=========================================="
echo "Sekarang buka masing-masing domain di browser."
echo "Anda akan otomatis diarahkan ke halaman Instalasi OpenSID."
echo ""
echo "PENTING - Saat ditanya detail database di halaman instalasi, isi dengan:"
echo "- Database Host: db"
echo "- Database User: opensid"
echo "- Database Password: opensid123"
echo "Lalu untuk 'Database Name' isi sesuai desanya:"
echo "  > desawawatu.web.id       : opensid_wawatu"
echo "  > desamatawawatu.web.id   : opensid_matawawatu"
echo "  > desatanjungtiram.web.id : opensid_tanjungtiram"
echo "  > lalowaru.web.id         : opensid_lalowaru"
echo "=========================================="
