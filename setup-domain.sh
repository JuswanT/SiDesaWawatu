#!/bin/bash
# ============================================
# Script Setup Domain desawawatu.web.id
# dengan HTTPS (Let's Encrypt)
# ============================================
# Jalankan sebagai root: sudo bash setup-domain.sh
# ============================================

set -e

DOMAIN="desawawatu.web.id"
EMAIL="admin@desawawatu.web.id"  # Ganti dengan email Anda
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
NGINX_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"

echo "=========================================="
echo "  Setup Domain: $DOMAIN"
echo "=========================================="

# 1. Install Nginx & Certbot
echo ""
echo "[1/6] Installing Nginx & Certbot..."
apt update
apt install -y nginx certbot python3-certbot-nginx

# 2. Buat konfigurasi Nginx (HTTP dulu untuk verifikasi Certbot)
echo ""
echo "[2/6] Creating Nginx configuration (HTTP)..."
cat > "$NGINX_CONF" << 'NGINX_EOF'
server {
    listen 80;
    server_name desawawatu.web.id www.desawawatu.web.id;

    client_max_body_size 50M;

    location / {
        proxy_pass http://127.0.0.1:6000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_connect_timeout 300;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg|eot)$ {
        proxy_pass http://127.0.0.1:6000;
        proxy_set_header Host $host;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    location ~ /\. {
        deny all;
    }

    access_log /var/log/nginx/desawawatu.access.log;
    error_log /var/log/nginx/desawawatu.error.log;
}
NGINX_EOF

# 3. Enable site & test
echo ""
echo "[3/6] Enabling Nginx site..."
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"

# Hapus default site jika ada (opsional)
# rm -f /etc/nginx/sites-enabled/default

nginx -t
systemctl reload nginx

echo ""
echo "[4/6] Nginx HTTP ready. Testing connection..."
sleep 2

# 4. Install SSL Certificate
echo ""
echo "[5/6] Installing SSL certificate with Let's Encrypt..."
echo "      Domain: $DOMAIN"
echo "      Email:  $EMAIL"
echo ""

certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos --email "$EMAIL" --redirect

# 5. Setup auto-renewal
echo ""
echo "[6/6] Setting up auto-renewal..."
systemctl enable certbot.timer
systemctl start certbot.timer

# Selesai
echo ""
echo "=========================================="
echo "  ✅ SETUP SELESAI!"
echo "=========================================="
echo ""
echo "  Domain  : https://$DOMAIN"
echo "  SSL     : Let's Encrypt (auto-renew)"
echo "  Proxy   : 127.0.0.1:6000 (Docker OpenSID)"
echo ""
echo "  Pastikan:"
echo "  1. DNS A record $DOMAIN → 210.87.89.81"
echo "  2. DNS A record www.$DOMAIN → 210.87.89.81"
echo "  3. Docker OpenSID sudah berjalan di port 6000"
echo ""
echo "  Test renewal: sudo certbot renew --dry-run"
echo "=========================================="
