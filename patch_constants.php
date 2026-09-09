<?php
$file = '/var/www/html/donjo-app/config/constants.php';
$content = file_get_contents($file);

// Kita ganti logika penentuan desa secara total dengan logika regex yang 100% akurat.
$new_logic = <<<'PHP'
$host = $_SERVER['HTTP_HOST'] ?? '';
$desa_dir = 'desa'; // Default fallback

// Cek domain untuk menentukan direktori desa
if (preg_match('/desamatawawatu\.web\.id/i', $host)) {
    $desa_dir = 'desa_matawawatu';
} elseif (preg_match('/desawawatu\.web\.id/i', $host)) {
    $desa_dir = 'desa_wawatu';
} elseif (preg_match('/desatanjungtiram\.web\.id/i', $host)) {
    $desa_dir = 'desa_tanjungtiram';
} elseif (preg_match('/lalowaru\.web\.id/i', $host)) {
    $desa_dir = 'desa_lalowaru';
}
PHP;

// Cari dan ganti blok lama
$content = preg_replace('/\$host = \$_SERVER\[\'HTTP_HOST\'\] \?\? \'\';.*\}\s*$/ism', $new_logic . "\n", $content);

file_put_contents($file, $content);
echo "Patch berhasil diterapkan ke constants.php\n";
