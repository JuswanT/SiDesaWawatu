#!/bin/bash
echo "======================================================"
echo "  DIAGNOSTIK MULTISITE & DATABASE OPENSID"
echo "======================================================"

echo "[1] Memeriksa Routing Domain di constants.php..."
docker exec opensid-app php -r '
$f = "/var/www/html/donjo-app/config/constants.php";
$c = file_get_contents($f);
$start = strpos($c, "// Menentukan direktori desa berdasarkan domain");
if ($start !== false) {
    $end = strpos($c, "// Fallback to default", $start);
    echo substr($c, $start, $end - $start) . "\n";
} else {
    echo "Gagal menemukan blok routing.\n";
}
'

echo "------------------------------------------------------"
echo "[2] Memeriksa Konfigurasi Database di Tiap Desa..."
echo "------------------------------------------------------"
DB_PASS=$(docker exec opensid-db printenv MYSQL_ROOT_PASSWORD | tr -d '\r')

# Loop folder desa di dalam container
DESA_FOLDERS=$(docker exec opensid-app ls -1 /var/www/html | grep "^desa_")

for DESA in $DESA_FOLDERS; do
    echo "Folder: $DESA"
    
    # Ambil nama database dari file database.php
    DB_NAME=$(docker exec opensid-app bash -c "grep \"\\\$db\['default'\]\['database'\]\" /var/www/html/$DESA/config/database.php | cut -d\"'\" -f4" || echo "")
    
    if [ -z "$DB_NAME" ]; then
        echo "  ❌ Konfigurasi database TIDAK DITEMUKAN atau KOSONG!"
        continue
    fi
    
    echo "  -> Terkoneksi ke Database : $DB_NAME"
    
    # Ambil nama desa dari tabel config di dalam database tersebut
    NAMA_DESA=$(docker exec opensid-db bash -c "mysql -u root -p\"$DB_PASS\" -D \"$DB_NAME\" -N -B -e \"SELECT nama_desa FROM config LIMIT 1;\" 2>/dev/null" || echo "")
    
    if [ -z "$NAMA_DESA" ]; then
        echo "  ❌ Gagal membaca tabel config di database $DB_NAME. Apakah database belum di-import?"
    else
        echo "  -> Identitas Nama Desa    : $NAMA_DESA"
        
        # Peringatan jika masih memakai opensid (default)
        if [ "$DB_NAME" == "opensid" ]; then
            echo "  ⚠️ PERINGATAN: Desa ini masih menggunakan database default (opensid)!"
        fi
    fi
    echo ""
done

echo "======================================================"
echo "✅ DIAGNOSTIK SELESAI"
echo "======================================================"
