#!/bin/bash
echo "======================================================"
echo " Menerapkan ulang patch HTTPS untuk Reverse Proxy"
echo "======================================================"

CONFIG_FILE="donjo-app/config/config.php"
CONSTANTS_FILE="donjo-app/config/constants.php"

# Hapus patch lama di bagian bawah constants.php jika ada
sed -i '/\/\/ PATCH: Deteksi HTTPS dari Reverse Proxy/,$d' "$CONSTANTS_FILE"

# Buat file PHP kecil untuk memodifikasi constants.php di baris paling atas
cat << 'EOF' > patcher.php
<?php
$file = 'donjo-app/config/constants.php';
$content = file_get_contents($file);
$patch = "\n// PATCH: Deteksi HTTPS dari Reverse Proxy\nif (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\n    \$_SERVER['HTTPS'] = 'on';\n}\n";

if (strpos($content, 'Deteksi HTTPS') === false) {
    // Insert patch right after <?php
    $content = preg_replace('/<\?php\s*/', "<?php\n" . $patch, $content, 1);
    file_put_contents($file, $content);
    echo ">> $file berhasil dipatch di baris atas.\n";
} else {
    echo ">> $file sudah dipatch sebelumnya.\n";
}
EOF
php patcher.php
rm patcher.php

# Patch config.php
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

echo "✅ Selesai! Coba REFRESH halaman https://desawawatu.web.id/siteman"
