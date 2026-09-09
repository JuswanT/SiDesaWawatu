#!/bin/bash
docker exec opensid-app php -r '
$f = "/var/www/html/index.php";
$c = file_get_contents($f);
// Kita HAPUS patch lama jika ada
$c = preg_replace("/<\?php\nif\(isset.*?HTTPS.*?on.*?\n/s", "<?php\n", $c);

// KITA PAKSA HTTPS SECARA MUTLAK (Unconditional)
$patch = "<?php\n\$_SERVER[\"HTTPS\"]=\"on\";\n";
$c = preg_replace("/<\?php/", $patch, $c, 1);
file_put_contents($f, $c);
echo "✅ HTTPS dipaksa aktif di index.php container!\n";
'
