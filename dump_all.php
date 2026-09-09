<?php
require 'vendor/autoload.php';
$routes = OpenSID\Route::getRoutes();
file_put_contents('routes_dump.txt', print_r($routes, true));
