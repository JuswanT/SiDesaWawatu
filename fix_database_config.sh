#!/bin/bash
echo "======================================================"
echo "  MEMPERBAIKI CONFIG DATABASE (MENGEMBALIKAN KREDENSIAL)"
echo "======================================================"

docker exec opensid-app php -r '
$folders = glob("/var/www/html/desa_*", GLOB_ONLYDIR);
foreach($folders as $dir) {
    $desa = basename($dir);
    echo "Memproses: $desa\n";
    
    // Nama database = opensid_ + (nama setelah desa_)
    $db_name = "opensid_" . substr($desa, 5);
    
    $config_dir = $dir . "/config";
    if (!is_dir($config_dir)) {
        mkdir($config_dir, 0755, true);
    }
    
    $db_file = $config_dir . "/database.php";
    
    // Kembalikan konfigurasi penuh untuk environment Docker
    $content = "<?php\n";
    $content .= "// Pengaturan khusus untuk $desa\n";
    $content .= "\$db[\x27default\x27][\x27hostname\x27] = \x27db\x27;\n";
    $content .= "\$db[\x27default\x27][\x27username\x27] = \x27opensid\x27;\n";
    $content .= "\$db[\x27default\x27][\x27password\x27] = \x27network2024\x27;\n";
    $content .= "\$db[\x27default\x27][\x27database\x27] = \x27$db_name\x27;\n";
    $content .= "\$db[\x27default\x27][\x27port\x27] = 3306;\n";
    
    file_put_contents($db_file, $content);
    echo "  ✅ Kredensial database.php berhasil dipulihkan & diperbarui!\n\n";
}
'

echo "======================================================"
echo "✅ SEMUA CONFIG DATABASE DESA BERHASIL DIPERBAIKI"
echo "======================================================"
