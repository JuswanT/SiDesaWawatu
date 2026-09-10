#!/bin/bash

echo "====================================================="
echo "   MENGATUR KONFIGURASI NGINX UNTUK 4 DESA"
echo "====================================================="

# Memastikan dijalankan dengan akses root/sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Harap jalankan skrip ini menggunakan sudo."
  echo "Contoh: sudo bash setup_nginx.sh"
  exit 1
fi

NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"

# Fungsi untuk membuat konfigurasi Nginx per desa
buat_konfigurasi() {
    local domain=$1
    local port=$2
    local conf_file="$NGINX_AVAILABLE/$domain.conf"

    echo "Membuat konfigurasi untuk $domain di port $port..."

    cat <<EOF > "$conf_file"
server {
    listen 80;
    server_name $domain www.$domain;

    location / {
        proxy_pass http://127.0.0.1:$port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

    # Buat symlink ke sites-enabled jika belum ada
    if [ ! -f "$NGINX_ENABLED/$domain.conf" ]; then
        ln -s "$conf_file" "$NGINX_ENABLED/$domain.conf"
    fi
}

# 1. Buat file konfigurasi masing-masing
buat_konfigurasi "desawawatu.web.id" 6000
buat_konfigurasi "desatanjungtiram.web.id" 6001
buat_konfigurasi "desalalowaru.web.id" 6002
buat_konfigurasi "desamatawawatu.web.id" 6003

echo ""
echo "2. Memeriksa sintaks Nginx..."
nginx -t

if [ $? -eq 0 ]; then
    echo ""
    echo "3. Merestart Nginx..."
    systemctl reload nginx
    echo "✅ SELESAI! Konfigurasi Nginx berhasil diterapkan."
else
    echo "❌ Terjadi kesalahan pada konfigurasi Nginx. Harap periksa pesan error di atas."
fi
