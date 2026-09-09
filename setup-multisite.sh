#!/bin/bash
# ============================================
# Script Setup Domain Multisite
# dengan HTTPS (Let's Encrypt)
# ============================================
# Jalankan sebagai root: sudo bash setup-multisite.sh
# ============================================

set -e

DOMAINS=("desamatawawatu.web.id" "desatanjungtiram.web.id" "lalowaru.web.id")
EMAIL="admin@desawawatu.web.id"  # Ganti dengan email Anda

echo "=========================================="
echo "  Setup Domain Multisite"
echo "=========================================="

echo ""
echo "[1/4] Installing Nginx & Certbot..."
apt update
apt install -y nginx certbot python3-certbot-nginx

for DOMAIN in "${DOMAINS[@]}"; do
    NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
    NGINX_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"

    echo "------------------------------------------"
    echo "  Memproses Domain: $DOMAIN"
    echo "------------------------------------------"

    echo "[2/4] Creating Nginx configuration (HTTP)..."
    cat > "$NGINX_CONF" << NGINX_EOF
server {
    listen 80;
    server_name $DOMAIN;

    client_max_body_size 50M;

    location / {
        proxy_pass http://127.0.0.1:6000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-Host \$host;

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_connect_timeout 300;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg|eot)$ {
        proxy_pass http://127.0.0.1:6000;
        proxy_set_header Host \$host;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    location ~ /\. {
        deny all;
    }

    access_log /var/log/nginx/${DOMAIN}.access.log;
    error_log /var/log/nginx/${DOMAIN}.error.log;
}
NGINX_EOF

    echo "[3/4] Enabling Nginx site..."
    ln -sf "$NGINX_CONF" "$NGINX_ENABLED"
    
done

nginx -t
systemctl reload nginx

sleep 2

echo ""
echo "[4/4] Installing SSL certificates with Let's Encrypt..."
for DOMAIN in "${DOMAINS[@]}"; do
    echo "      Requesting SSL for: $DOMAIN"
    certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAIL" --redirect || echo "Gagal memasang SSL untuk $DOMAIN (Mungkin DNS belum diarahkan ke server ini)"
done

echo ""
echo "=========================================="
echo "  ✅ SETUP MULTISITE SELESAI!"
echo "=========================================="
echo "  Domain yang telah diproses:"
for DOMAIN in "${DOMAINS[@]}"; do
    echo "  - https://$DOMAIN"
done
echo "=========================================="
