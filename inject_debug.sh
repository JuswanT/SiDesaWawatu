#!/bin/bash
echo "======================================================"
echo "  MENAMBAHKAN INDIKATOR DATABASE DI HALAMAN LOGIN"
echo "======================================================"

# Kita tambahkan baris kecil di bagian bawah form login untuk debugging
docker exec opensid-app php -r '
$f = "/var/www/html/donjo-app/views/siteman.php";
if (file_exists($f)) {
    $c = file_get_contents($f);
    
    // Hapus indikator lama jika ada
    $c = preg_replace("/<!-- DEBUG_DB -->.*?<!-- \/DEBUG_DB -->/s", "", $c);
    
    // Tambahkan indikator baru tepat sebelum tag </body>
    $debug_html = "\n<!-- DEBUG_DB -->\n<div style=\"position:fixed; bottom:10px; left:10px; background:red; color:white; padding:10px; z-index:9999;\">\n<?php \ninclude LOKASI_CONFIG_DESA . \x27database.php\x27; \necho \x27Domain: \x27 . (\$_SERVER[\x27HTTP_HOST\x27] ?? \x27Kosong\x27) . \x27 | Folder: \x27 . LOKASI_CONFIG_DESA . \x27 | DB: \x27 . \$db[\x27default\x27][\x27database\x27]; \n?>\n</div>\n<!-- /DEBUG_DB -->\n</body>";
    
    $c = str_replace("</body>", $debug_html, $c);
    file_put_contents($f, $c);
    echo "✅ Indikator debugging berhasil dipasang di siteman.php!\n";
} else {
    echo "❌ File siteman.php tidak ditemukan!\n";
}
'
