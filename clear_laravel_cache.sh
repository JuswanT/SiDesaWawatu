#!/bin/bash
echo "Membersihkan semua cache Laravel (File, View, Config, Route)..."
docker exec opensid-app php artisan cache:clear
docker exec opensid-app php artisan config:clear
docker exec opensid-app php artisan view:clear
docker exec opensid-app php artisan route:clear

echo "Menghapus sisa cache file secara manual..."
docker exec opensid-app bash -c "rm -rf /var/www/html/storage/framework/cache/data/*"
docker exec opensid-app bash -c "rm -rf /var/www/html/storage/framework/views/*"

echo "Cache berhasil dibersihkan!"
