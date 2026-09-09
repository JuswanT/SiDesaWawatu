<?php
try {
    define('ENVIRONMENT', 'development');
    define('FCPATH', __DIR__ . DIRECTORY_SEPARATOR);
    define('APPPATH', __DIR__ . '/donjo-app/');
    define('BASEPATH', __DIR__ . '/vendor/codeigniter/framework/system/');
    define('DESAPATH', __DIR__ . '/desa/');
    
    require 'vendor/autoload.php';
    $app = require 'bootstrap/app.php';
    $app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
    $f = new ReflectionFunction('identitas');
    $start = $f->getStartLine() - 1;
    $end = $f->getEndLine();
    $lines = file($f->getFileName());
    echo "FILE: " . $f->getFileName() . "\n";
    echo implode('', array_slice($lines, $start, $end - $start));
} catch (Throwable $e) {
    echo "ERROR: " . $e->getMessage();
}
