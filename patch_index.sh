#!/bin/bash
docker exec opensid-app php -r '
$f = "/var/www/html/index.php";
$c = file_get_contents($f);
if (strpos($c, "HTTP_X_FORWARDED_PROTO") === false) {
    $patch = "<?php\nif(isset(\$_SERVER[\"HTTP_X_FORWARDED_PROTO\"]) && \$_SERVER[\"HTTP_X_FORWARDED_PROTO\"]===\"https\") { \$_SERVER[\"HTTPS\"]=\"on\"; }\n";
    $c = preg_replace("/<\?php/", $patch, $c, 1);
    file_put_contents($f, $c);
    echo "✅ Patch HTTPS berhasil diterapkan di index.php container!\n";
} else {
    echo "✅ Patch HTTPS sudah ada di index.php container!\n";
}
'
