<?php
$_SERVER['HTTP_HOST'] = 'localhost'; // Test fallback
require_once 'donjo-app/config/constants.php';
var_dump(DESA_DIR);
var_dump(LOKASI_CONFIG_DESA);
var_dump(file_exists(LOKASI_CONFIG_DESA . 'database.php'));
