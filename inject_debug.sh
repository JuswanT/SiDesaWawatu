#!/bin/bash
echo "======================================================"
echo "  MENAMBAHKAN INDIKATOR DATABASE DI SEMUA HALAMAN"
echo "======================================================"

# Kita tambahkan baris kecil di bagian akhir index.php untuk debugging
docker exec opensid-app php -r '
$f = "/var/www/html/index.php";
if (file_exists($f)) {
    $c = file_get_contents($f);
    
    // Hapus indikator lama jika ada
    $c = preg_replace("/\/\* DEBUG_DB \*\/.*?\/\* \/DEBUG_DB \*\//s", "", $c);
    
    // Tambahkan indikator baru tepat di bagian paling bawah
    $debug_php = "\n/* DEBUG_DB */\ninclude LOKASI_CONFIG_DESA . \x27database.php\x27;\necho \"<div style=\x27position:fixed; bottom:10px; left:10px; background:red; color:white; padding:10px; z-index:999999; font-weight:bold; border-radius:5px; border: 2px solid white;\x27>\";\necho \"Domain Dideteksi: \" . (\$_SERVER[\x27HTTP_HOST\x27] ?? \"Kosong\") . \"<br>\";\necho \"Folder Aktif: \" . LOKASI_CONFIG_DESA . \"<br>\";\necho \"Terkoneksi ke DB: \" . \$db[\x27default\x27][\x27database\x27];\necho \"</div>\";\n/* /DEBUG_DB */\n";
    
    // Tempel di baris paling akhir file index.php
    file_put_contents($f, $c . $debug_php);
    echo "✅ Indikator debugging berhasil dipasang di index.php!\n";
} else {
    echo "❌ File index.php tidak ditemukan!\n";
}
'
