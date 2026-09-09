#!/bin/bash
echo "======================================================"
echo "  MEMBUAT & MEMPERBAIKI CONFIG DATABASE TIAP DESA"
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
    if (!file_exists($db_file)) {
        echo "  -> File database.php TIDAK ADA. Membuat baru...\n";
        $content = "<?php\n// Pengaturan khusus untuk $desa\n\$db[\x27default\x27][\x27database\x27] = \x27$db_name\x27;\n";
        file_put_contents($db_file, $content);
        echo "  ✅ Berhasil dibuat!\n";
    } else {
        echo "  -> File database.php sudah ada. Memperbarui isinya...\n";
        $c = file_get_contents($db_file);
        
        // Cek apakah string literal $DB_NAME ada (akibat bug script sebelumnya)
        if (strpos($c, "\x27\$DB_NAME\x27") !== false) {
            $c = str_replace("\x27\$DB_NAME\x27", "\x27$db_name\x27", $c);
        }
        
        // Update database configuration
        if (preg_match("/\\\$db\\[\x27default\x27\\]\\[\x27database\x27\\]\s*=\s*\x27.*?\x27;/", $c)) {
            $c = preg_replace("/\\\$db\\[\x27default\x27\\]\\[\x27database\x27\\]\s*=\s*\x27.*?\x27;/", "\$db[\x27default\x27][\x27database\x27] = \x27$db_name\x27;", $c);
        } else {
            $c .= "\n\$db[\x27default\x27][\x27database\x27] = \x27$db_name\x27;\n";
        }
        file_put_contents($db_file, $c);
        echo "  ✅ Berhasil diperbarui!\n";
    }
}
'
