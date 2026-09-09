<?php
require 'c:/laragon/www/php/SID/OpenSID/vendor/autoload.php';
$routes = OpenSID\Route::getRoutes();
file_put_contents('c:/laragon/www/php/SID/OpenSID/all_routes.json', json_encode($routes, JSON_PRETTY_PRINT));
