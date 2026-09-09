<?php
$constants_file = '/var/www/html/donjo-app/config/constants.php';
$config_file = '/var/www/html/donjo-app/config/config.php';

// 1. Fix constants.php
$constants = file_get_contents($constants_file);

// Hapus logika lama jika ada
$constants = preg_replace('/\/\/ Menentukan direktori desa berdasarkan domain aktif.*?define\(\'DESA_DIR\', \$desa_dir \. \'\/\'\);/s', "define('DESA_DIR', \$desa_dir . '/');", $constants);

$multisite_logic = <<<'PHP'
// Menentukan direktori desa berdasarkan domain aktif (Multisite Support)
$host = $_SERVER['HTTP_HOST'] ?? '';
$desa_dir = 'desa'; // Default fallback

// Gunakan preg_match untuk exact match
if (preg_match('/^desawawatu\.web\.id/i', $host)) {
    $desa_dir = 'desa_wawatu';
} elseif (preg_match('/^desamatawawatu\.web\.id/i', $host)) {
    $desa_dir = 'desa_matawawatu';
} elseif (preg_match('/^desatanjungtiram\.web\.id/i', $host)) {
    $desa_dir = 'desa_tanjungtiram';
} elseif (preg_match('/^lalowaru\.web\.id/i', $host)) {
    $desa_dir = 'desa_lalowaru';
}

if (!is_dir(FCPATH . $desa_dir)) {
    $desa_dir = 'desa';
}

define('DESA_DIR', $desa_dir . '/');
PHP;

// Sisipkan logika multisite tepat sebelum DESA_DIR define pertama kali
$constants = str_replace("define('DESA_DIR', 'desa/');", $multisite_logic, $constants);
$constants = preg_replace('/\$desa_dir \= \'desa\';\s*define\(\'DESA_DIR\', \$desa_dir \. \'\/\'\);/s', $multisite_logic, $constants);
$constants = preg_replace('/define\(\'DESA_DIR\', \$desa_dir \. \'\/\'\);/s', $multisite_logic, $constants, 1);


file_put_contents($constants_file, $constants);


// 2. Fix config.php for HTTPS Mixed Content
$config_content = file_get_contents($config_file);
$config_content = preg_replace('/\$config\[\'proxy_ips\'\]\s*=\s*\'\';/i', "\$config['proxy_ips'] = isset(\$_SERVER['REMOTE_ADDR']) ? \$_SERVER['REMOTE_ADDR'] : '';\n\$config['cookie_secure'] = true;", $config_content);
file_put_contents($config_file, $config_content);

echo "Perbaikan Selesai!\n";
