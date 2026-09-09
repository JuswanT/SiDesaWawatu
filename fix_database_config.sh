#!/bin/bash
echo "======================================================"
echo "  MEMBUAT & MEMPERBAIKI CONFIG DATABASE TIAP DESA"
echo "======================================================"

DESA_FOLDERS=$(docker exec opensid-app ls -1 /var/www/html | grep "^desa_")

for DESA in $DESA_FOLDERS; do
    echo "------------------------------------------------------"
    echo "Memproses Folder: $DESA"
    
    DB_NAME="opensid_${DESA#desa_}"
    echo "Target Database : $DB_NAME"
    
    # Buat folder config jika belum ada di dalam container
    docker exec opensid-app mkdir -p /var/www/html/$DESA/config
    
    # Cek apakah file database.php sudah ada
    HAS_DB=$(docker exec opensid-app bash -c "[ -f /var/www/html/$DESA/config/database.php ] && echo 'yes' || echo 'no'")
    
    if [ "$HAS_DB" == "no" ]; then
        echo "  -> File database.php TIDAK ADA. Membuat baru..."
        
        # Buat file database.php baru dengan konfigurasi yang menunjuk ke database masing-masing
        docker exec opensid-app bash -c "cat > /var/www/html/$DESA/config/database.php << 'EOF'
<?php
// Pengaturan khusus untuk $DESA
\$db['default']['database'] = '$DB_NAME';
EOF"
        echo "  ✅ File database.php berhasil dibuat!"
    else
        echo "  -> File database.php sudah ada. Memperbarui isinya..."
        
        # Update nama database di file yang sudah ada
        # Kita replace atau tambahkan
        docker exec opensid-app bash -c "grep -q \"\\\$db\['default'\]\['database'\]\" /var/www/html/$DESA/config/database.php && sed -i \"s/\\\$db\['default'\]\['database'\].*/\\\$db['default']['database'] = '$DB_NAME';/g\" /var/www/html/$DESA/config/database.php || echo \"\\\$db['default']['database'] = '$DB_NAME';\" >> /var/www/html/$DESA/config/database.php"
        
        echo "  ✅ File database.php berhasil diperbarui!"
    fi
done

echo "======================================================"
echo "✅ SEMUA CONFIG DATABASE DESA BERHASIL DIPERBAIKI"
echo "======================================================"
echo "Silakan jalankan ulang 'bash check_all_db.sh' untuk memastikan."
