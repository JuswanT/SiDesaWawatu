#!/bin/bash
echo "====================================================="
echo "   PENYELESAIAN FINAL (DATABASE & APP KEY)"
echo "====================================================="

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi
DB_PASS=${DB_ROOT_PASSWORD:-rahasia123}
DB_USER=${DB_USERNAME:-opensid}
DB_HOST="opensid-db"
DB_KEY="base64:bdUU5qnGGkXA7UctYClIFDsbcbldrRqxhUUEkosDdzY="

for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "Menyusun ulang konfigurasi $desa..."
    
    # 1. Hapus direktori hantu di dalam container (untuk berjaga-jaga)
    docker exec opensid-$desa rm -rf /var/www/html/desa_$desa 2>/dev/null
    
    # 2. Buat ulang database.php dengan LENGKAP agar koneksi tidak gagal
    mkdir -p "desa_$desa/config"
    cat <<EOF > "desa_$desa/config/database.php"
<?php
\$db['default']['hostname'] = '$DB_HOST';
\$db['default']['username'] = 'root';
\$db['default']['password'] = '$DB_PASS';
\$db['default']['database'] = 'opensid_$desa';
\$db['default']['dbdriver'] = 'mysqli';
\$db['default']['pconnect'] = FALSE;
\$db['default']['db_debug'] = (ENVIRONMENT !== 'production');
\$db['default']['cache_on'] = FALSE;
\$db['default']['cachedir'] = '';
\$db['default']['char_set'] = 'utf8mb4';
\$db['default']['dbcollat'] = 'utf8mb4_general_ci';
EOF

    # 3. Tulis ulang app_key dengan benar
    echo -n "$DB_KEY" > "desa_$desa/app_key"
    
    # Hapus file .env yang salah tempat (jika ada)
    rm -f "desa_$desa/.env" 2>/dev/null
    
    # 4. Hapus cache Laravel/CI secara ekstrim di sisi host
    rm -rf storage_$desa/framework/cache/data/* 2>/dev/null
    rm -rf storage_$desa/framework/views/* 2>/dev/null
    rm -rf storage_$desa/framework/sessions/* 2>/dev/null
    
    echo "✅ $desa selesai diperbaiki."
done

echo "Restarting containers untuk membuang cache memori (OPcache)..."
docker-compose restart

echo "====================================================="
echo "✅ SEMUA DESA BERHASIL DI-RESET & DISINKRONKAN!"
echo "Silakan Hard Refresh (Ctrl + F5) atau buka lewat mode penyamaran (Incognito)."
echo "====================================================="
