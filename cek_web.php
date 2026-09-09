<?php
require "vendor/autoload.php";

echo "<h1>DIAGNOSTIK DARI BROWSER</h1>";
echo "HTTP_HOST: " . ($_SERVER['HTTP_HOST'] ?? 'KOSONG') . "<br>";

$app = require_once "bootstrap/app.php";
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$dbName = config('database.connections.mysql.database');
echo "Laravel terkoneksi ke DB: " . $dbName . "<br>";

try {
    $desa = Illuminate\Support\Facades\DB::table('config')->first();
    echo "Nama Desa (Laravel DB): " . ($desa ? $desa->nama_desa : 'KOSONG') . "<br>";
} catch (Exception $e) {
    echo "Error Laravel: " . $e->getMessage() . "<br>";
}

echo "CodeIgniter database.php test:<br>";
if (file_exists('donjo-app/config/constants.php')) {
    echo "Constants exist.<br>";
}
