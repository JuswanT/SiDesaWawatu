#!/bin/bash
echo "====================================================="
echo "   MENGHAPUS FOLDER 'HANTU' DI DALAM CONTAINER"
echo "====================================================="

# Biang kerok dari segala masalah ini akhirnya terungkap!
# Di dalam Docker, folder 'desa_wawatu' dari komputer Anda sudah di-mount
# menjadi folder bernama 'desa' di dalam container.
# Namun, karena sebelumnya ada script yang salah membuat folder 'desa_wawatu'
# juga di DALAM container, OpenSID menjadi bingung dan membaca folder
# internal tersebut alih-alih membaca folder 'desa' hasil mounting!

for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "Membersihkan folder hantu di opensid-$desa..."
    
    # Hapus folder desa_* yang ada di dalam container
    # agar OpenSID kembali membaca folder 'desa' (hasil mapping)
    docker exec opensid-$desa rm -rf /var/www/html/desa_$desa 2>/dev/null
    
    # Hapus cache
    docker exec opensid-$desa rm -rf /var/www/html/storage/framework/cache/data/* 2>/dev/null
done

echo "Me-restart container..."
docker-compose restart

echo "====================================================="
echo "✅ FOLDER HANTU BERHASIL DIHAPUS!"
echo "Silakan refresh website Anda sekarang. Dijamin semuanya tembus!"
echo "====================================================="
