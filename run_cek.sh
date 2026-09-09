#!/bin/bash
echo "Menjalankan cek_eloquent.php di dalam container..."
docker exec opensid-app php /var/www/html/cek_eloquent.php
