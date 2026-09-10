#!/bin/bash
echo "====================================================="
echo "   MEMBUAT APP_KEY UNTUK MASING-MASING DESA"
echo "====================================================="

for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "Membuat konfigurasi .env untuk $desa..."
    
    # 1. Hasilkan APP_KEY random (base64) format standar Laravel/OpenSID
    APP_KEY="base64:$(openssl rand -base64 32)"
    
    # 2. Buat atau tambahkan ke file .env di folder desa
    ENV_FILE="desa_$desa/.env"
    
    # Jika file .env belum ada, kita buat baru
    if [ ! -f "$ENV_FILE" ]; then
        touch "$ENV_FILE"
    fi
    
    # Cek apakah APP_KEY sudah ada, jika belum tambahkan
    if grep -q "APP_KEY=" "$ENV_FILE"; then
        sed -i "s/^APP_KEY=.*/APP_KEY=$APP_KEY/" "$ENV_FILE"
    else
        echo "APP_KEY=$APP_KEY" >> "$ENV_FILE"
    fi
    
    # 3. (Opsional) Tetapkan config.php untuk CodeIgniter encryption_key
    CONFIG_FILE="desa_$desa/config/config.php"
    mkdir -p "desa_$desa/config"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "<?php" > "$CONFIG_FILE"
    fi
    
    # Cek apakah encryption_key sudah ada
    if ! grep -q "encryption_key" "$CONFIG_FILE"; then
        CI_KEY=$(openssl rand -hex 16)
        echo "\$config['encryption_key'] = '$CI_KEY';" >> "$CONFIG_FILE"
    fi
    
    echo "✅ Berhasil membuat kunci unik untuk $desa"
done

echo "Me-restart container..."
docker-compose restart

echo "SELESAI!"
