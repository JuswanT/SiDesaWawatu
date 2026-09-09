<?php
$host = $_SERVER['HTTP_HOST'] ?? '';
$desa_dir = 'desa'; // Default fallback

// Urutan pengecekan sangat penting.
// Cek nama yang lebih panjang ("desamatawawatu") SEBELUM nama yang lebih pendek ("desawawatu")
// agar tidak terjadi tabrakan/bug substring.
if (strpos($host, 'desamatawawatu.web.id') !== false) {
    $desa_dir = 'desa_matawawatu';
} elseif (strpos($host, 'desawawatu.web.id') !== false) {
    $desa_dir = 'desa_wawatu';
} elseif (strpos($host, 'desatanjungtiram.web.id') !== false) {
    $desa_dir = 'desa_tanjungtiram';
} elseif (strpos($host, 'lalowaru.web.id') !== false) {
    $desa_dir = 'desa_lalowaru';
}

echo "HTTP_HOST: " . $host . "\n";
echo "DESA_DIR: " . $desa_dir . "\n";
