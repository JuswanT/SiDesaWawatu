#!/bin/bash
echo "Mengecek apakah kata Lalowaru di-hardcode dalam tema Wawatu..."
docker exec opensid-app grep -ri "Lalowaru" /var/www/html/desa_wawatu/themes/ || echo "Tidak ada hardcode di themes."
docker exec opensid-app grep -ri "Lalowaru" /var/www/html/desa_wawatu/ || echo "Tidak ada hardcode di desa_wawatu."
