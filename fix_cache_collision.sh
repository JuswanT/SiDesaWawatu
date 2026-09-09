#!/bin/bash
echo "======================================================"
echo "  MEMBERSIHKAN CACHE & MEMPERBAIKI TABRAKAN CACHE"
echo "======================================================"

echo "[1] Membersihkan Cache Laravel di dalam Container..."
docker exec opensid-app php artisan cache:clear
docker exec opensid-app php artisan config:clear
docker exec opensid-app php artisan view:clear

echo "[2] Memisahkan Kunci Cache untuk Setiap Desa..."
docker exec opensid-app php -r '
$f = "/var/www/html/config/cache.php";
if (file_exists($f)) {
    $c = file_get_contents($f);
    
    // Cari prefix yang statis
    $old_prefix = "\x27prefix\x27 => Str::slug(\x27opensid\x27, \x27_\x27) . \x27_cache_\x27,";
    // Buat prefix dinamis berdasarkan domain yang sedang diakses
    $new_prefix = "\x27prefix\x27 => Str::slug(\x27opensid\x27, \x27_\x27) . \x27_cache_\x27 . str_replace(\x27.\x27, \x27_\x27, \$_SERVER[\x27HTTP_HOST\x27] ?? \x27default\x27),";
    
    if (strpos($c, $old_prefix) !== false) {
        $c = str_replace($old_prefix, $new_prefix, $c);
        file_put_contents($f, $c);
        echo "✅ Prefix cache berhasil dibuat dinamis berdasarkan domain!\n";
    } else {
        echo "⚠️ Prefix sudah diubah sebelumnya atau tidak ditemukan.\n";
    }
} else {
    echo "❌ File config/cache.php tidak ditemukan!\n";
}
'

echo "======================================================"
echo "✅ PROSES SELESAI"
echo "======================================================"
