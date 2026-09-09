#!/bin/bash
echo "Mencari kata Lalowaru di folder desa_wawatu..."
docker exec opensid-app grep -rni "Lalowaru" /var/www/html/desa_wawatu/

echo "Selesai!"
