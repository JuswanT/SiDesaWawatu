<?php
require 'c:/laragon/www/php/SID/OpenSID/vendor/autoload.php';
$routes = OpenSID\Route::getRoutes();
foreach ($routes as $path => $target) {
    if (strpos($path, 'fadmin') !== false || strpos($path, 'siteman') !== false || strpos($path, 'login') !== false || strpos($path, 'auth') !== false) {
        echo "$path => $target\n";
    }
}
