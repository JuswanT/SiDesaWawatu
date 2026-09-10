#!/bin/bash
echo "====================================================="
echo "   SINKRONISASI APP_KEY (FILE vs DATABASE)"
echo "====================================================="

# OpenSID mewajibkan isi dari file 'app_key' di folder desa 
# HARUS SAMA PERSIS dengan yang ada di tabel 'config' database.
# Karena semua desa di-install menggunakan opensid.sql yang sama,
# maka AppKey di database mereka adalah bawaan dari SQL tersebut.

DB_KEY="base64:bdUU5qnGGkXA7UctYClIFDsbcbldrRqxhUUEkosDdzY="

for desa in wawatu matawawatu tanjungtiram lalowaru; do
    echo "Memperbaiki AppKey untuk $desa..."
    
    # Tulis key yang sesuai ke dalam file desa_*/app_key
    echo -n "$DB_KEY" > "desa_$desa/app_key"
    
    # Hapus file .env yang dibuat sebelumnya agar OpenSID fokus membaca app_key
    if [ -f "desa_$desa/.env" ]; then
        rm -f "desa_$desa/.env"
    fi
    
    echo "✅ $desa tersinkron: $DB_KEY"
done

echo "====================================================="
echo "✅ SINKRONISASI SELESAI!"
echo "Silakan refresh website Anda. Peringatan AppKey akan hilang."
echo "====================================================="
