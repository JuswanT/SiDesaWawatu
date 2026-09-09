#!/bin/bash
echo "======================================================"
echo "  MEMBERSIHKAN SELURUH CACHE & SESSION (HARD RESET)"
echo "======================================================"

echo "Membersihkan Cache CodeIgniter (View Cache)..."
docker exec opensid-app bash -c "rm -rf /var/www/html/desa_*/cache/* 2>/dev/null"
docker exec opensid-app bash -c "rm -rf /var/www/html/donjo-app/cache/* 2>/dev/null"

echo "Membersihkan Cache & Sessions Laravel..."
docker exec opensid-app bash -c "rm -rf /var/www/html/storage/framework/cache/data/* 2>/dev/null"
docker exec opensid-app bash -c "rm -rf /var/www/html/storage/framework/sessions/* 2>/dev/null"
docker exec opensid-app php artisan cache:clear 2>/dev/null
docker exec opensid-app php artisan view:clear 2>/dev/null

echo "======================================================"
echo "✅ SELURUH CACHE TELAH DIBERSIHKAN!"
echo "======================================================"
