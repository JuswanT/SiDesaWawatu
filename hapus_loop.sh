#!/bin/bash
echo "====================================================="
echo "   MEMPERBAIKI REDIRECT LOOP (ERR_TOO_MANY_REDIRECTS)"
echo "====================================================="

# Masalah utamanya adalah Apache di dalam kontainer mencoba "Memaksa HTTPS" 
# melalui file .htaccess, padahal Nginx dan Cloudflare di depannya 
# sudah mengatur itu. Ini menyebabkan perulangan tak berujung (Loop).

for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "Memperbaiki .htaccess di opensid-$desa..."
    # Menonaktifkan paksaan HTTPS di tingkat Apache
    docker exec opensid-$desa sed -i 's/RewriteCond %{HTTPS} off/#RewriteCond %{HTTPS} off/g' /var/www/html/.htaccess 2>/dev/null
    docker exec opensid-$desa sed -i 's/RewriteRule ^(.*)$ https:\/\/%{HTTP_HOST}%{REQUEST_URI} \[L,R=301\]/#RewriteRule ^(.*)$ https:\/\/%{HTTP_HOST}%{REQUEST_URI} [L,R=301]/g' /var/www/html/.htaccess 2>/dev/null
done

echo "Me-restart layanan..."
docker-compose restart

echo "====================================================="
echo "✅ PERBAIKAN LOOP SELESAI!"
echo "PENTING: Browser Anda pasti masih menyimpan 'cache redirect' dari error sebelumnya."
echo "Anda WAJIB menekan Ctrl + F5 (Hard Refresh) atau Hapus Cache Browser"
echo "agar efek perbaikannya terasa dan situs bisa dimuat normal."
echo "====================================================="
