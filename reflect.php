<?php
define('FCPATH', __DIR__ . DIRECTORY_SEPARATOR);
require 'vendor/autoload.php';
$app = require 'bootstrap/app.php';
try {
    $f = new ReflectionFunction('identitas');
    echo "\n== FOUND ==\n" . $f->getFileName() . "\n";
} catch (Exception $e) {
    echo "\n== NOT FOUND ==\n";
}
