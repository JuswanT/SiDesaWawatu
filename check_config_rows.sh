#!/bin/bash
echo "Mengecek isi tabel config di opensid_wawatu..."
docker exec opensid-db mysql -u opensid -pnetwork2024 opensid_wawatu -e "SELECT id, nama_desa FROM config LIMIT 5;"
