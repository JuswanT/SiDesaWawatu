#!/bin/bash
docker exec opensid-app php -r '
$f = "/var/www/html/donjo-app/config/constants.php";
$c = file_get_contents($f);

// Mencari blok if else penentuan desa_dir
$start = strpos($c, "if (preg_match(\x27/^desawawatu");
if ($start === false) {
    $start = strpos($c, "if (strpos(\$host, \x27wawatu\x27)");
}

if ($start !== false) {
    $end = strpos($c, "}", strpos($c, "desa_lalowaru\x27;")) + 1;
    $old_block = substr($c, $start, $end - $start);
    
    $new_block = "if (strpos(\$host, \x27matawawatu\x27) !== false) {
    \$desa_dir = \x27desa_matawawatu\x27;
} elseif (strpos(\$host, \x27wawatu\x27) !== false) {
    \$desa_dir = \x27desa_wawatu\x27;
} elseif (strpos(\$host, \x27tanjungtiram\x27) !== false) {
    \$desa_dir = \x27desa_tanjungtiram\x27;
} elseif (strpos(\$host, \x27lalowaru\x27) !== false) {
    \$desa_dir = \x27desa_lalowaru\x27;
}";

    $c = str_replace($old_block, $new_block, $c);
    file_put_contents($f, $c);
    echo "✅ Routing folder desa per domain berhasil diperbaiki!\n";
} else {
    echo "Pola tidak ditemukan, mungkin sudah diperbaiki.\n";
}
'
