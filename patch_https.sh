#!/bin/bash
echo "======================================================"
echo " Menerapkan patch HTTPS untuk Reverse Proxy (Cloudflare/Nginx)"
echo "======================================================"

CONFIG_FILE="donjo-app/config/config.php"
CONSTANTS_FILE="donjo-app/config/constants.php"

if ! grep -q "HTTP_X_FORWARDED_PROTO" "$CONSTANTS_FILE"; then
    echo ">> Patching $CONSTANTS_FILE..."
    cat << 'PATCH' >> "$CONSTANTS_FILE"

// PATCH: Deteksi HTTPS dari Reverse Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}
PATCH
else
    echo ">> $CONSTANTS_FILE sudah dipatch sebelumnya."
fi

if ! grep -q "proxy_ips" "$CONFIG_FILE"; then
    echo ">> Patching $CONFIG_FILE..."
    cat << 'PATCH' >> "$CONFIG_FILE"

// PATCH: Trust proxy IPs dan Cookie Secure
$config['proxy_ips'] = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';
$config['cookie_secure'] = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') ? TRUE : FALSE;
PATCH
else
    echo ">> $CONFIG_FILE sudah dipatch sebelumnya."
fi

echo ">> Mengcopy file patch ke dalam container opensid-app..."
docker cp "$CONFIG_FILE" opensid-app:/var/www/html/"$CONFIG_FILE"
docker cp "$CONSTANTS_FILE" opensid-app:/var/www/html/"$CONSTANTS_FILE"

echo "✅ Selesai! Coba buka URL berikut di browser:"
echo "👉 https://desawawatu.web.id/siteman"
