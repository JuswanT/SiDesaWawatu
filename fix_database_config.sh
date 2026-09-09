#!/bin/bash
echo "======================================================"
echo "  MENGHAPUS & MEMBUAT ULANG CONFIG DATABASE TIAP DESA"
echo "======================================================"

docker exec opensid-app php -r '
$folders = glob("/var/www/html/desa_*", GLOB_ONLYDIR);
foreach($folders as $dir) {
    $desa = basename($dir);
    echo "Memproses: $desa\n";
    
    // Nama database = opensid_ + (nama setelah desa_)
    $db_name = "opensid_" . substr($desa, 5);
    echo "Target Database: $db_name\n";
    
    $config_dir = $dir . "/config";
    if (!is_dir($config_dir)) {
        mkdir($config_dir, 0755, true);
    }
    
    $db_file = $config_dir . "/database.php";
    
    // HAPUS dan BUAT ULANG secara bersih (overwrite)
    $content = "<?php\n// Pengaturan khusus untuk $desa\n\$db[\x27default\x27][\x27database\x27] = \x27$db_name\x27;\n";
    
    file_put_contents($db_file, $content);
    echo "  ✅ File database.php berhasil dibuat ulang secara bersih!\n\n";
}
'

echo "======================================================"
echo "✅ SEMUA CONFIG DATABASE DESA BERHASIL DIPERBAIKI"
echo "======================================================"
echo "Silakan jalankan ulang 'bash check_all_db.sh' untuk memastikan."
