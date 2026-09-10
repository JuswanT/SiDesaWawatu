#!/bin/bash
echo "====================================================="
echo "   PEMBERSIHAN TOTAL & SINKRONISASI AKHIR"
echo "====================================================="

# AppKey yang SEBENARNYA ada di tabel database semua desa ternyata adalah:
DB_KEY="base64:7j3Z92jVUbGWYTDZ6DJWlZIZydM7Y/t3TYwBUTZ6EWs="

for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "Menulis AppKey yang benar ke file $desa..."
    echo -n "$DB_KEY" > "desa_$desa/app_key"
    
    # Bersihkan sisa-sisa cache di sisi host
    rm -rf "storage_$desa/framework/cache/data/"* 2>/dev/null
    rm -rf "storage_$desa/framework/views/"* 2>/dev/null
    rm -rf "storage_$desa/framework/sessions/"* 2>/dev/null
done

echo "====================================================="
echo "Menghancurkan container lama yang kotor..."
echo "(Ini akan otomatis membasmi semua folder hantu di dalamnya)"
docker-compose down

echo "Membangun dan menyalakan ulang container baru yang bersih..."
docker-compose up -d

echo "====================================================="
echo "✅ SEMUANYA SELESAI!"
echo "Silakan Hard Refresh (Ctrl + F5) website Anda sekarang!"
echo "====================================================="
