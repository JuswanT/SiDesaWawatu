#!/bin/bash
echo "Mengecek baris config di opensid_wawatu..."
docker exec opensid-db mysql -u opensid -pnetwork2024 opensid_wawatu -e "SELECT id, nama_desa FROM config;"

echo "Mengecek baris config di opensid_tanjungtiram..."
docker exec opensid-db mysql -u opensid -pnetwork2024 opensid_tanjungtiram -e "SELECT id, nama_desa FROM config;"
