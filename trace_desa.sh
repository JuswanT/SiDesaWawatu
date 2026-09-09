#!/bin/bash
echo "======================================================"
echo "  MELACAK SUMBER DATA NAMA DESA"
echo "======================================================"

echo "1. Mengecek isi asli dari Database opensid_wawatu..."
docker exec opensid-db mysql -u opensid -pnetwork2024 opensid_wawatu -e "SELECT id, nama_desa FROM config;"

echo ""
echo "2. Mengecek file apa saja yang di-load di frontend..."
docker exec opensid-app php -r '
require "index.php"; // Ini akan crash karena butuh request, tapi kita tangkap outputnya
' 2>/dev/null
