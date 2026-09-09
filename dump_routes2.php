<?php
require 'c:/laragon/www/php/SID/OpenSID/vendor/autoload.php';
$routes = OpenSID\Route::getRoutes();
foreach ($routes as $path => $target) {
    if (strpos($path, 'layanan-mandiri') !== false || strpos($path, 'cetak') !== false) {
        echo "$path => $target\n";
    }
}
