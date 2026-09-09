<?php
// Script untuk mengecek secara langsung data dari Eloquent vs PDO
require "vendor/autoload.php";
$app = require_once "bootstrap/app.php";
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

// Ambil koneksi database Laravel saat ini
$dbName = config('database.connections.mysql.database');
echo "Laravel terkoneksi ke DB: " . $dbName . "\n";

// Coba query langsung pakai Eloquent
try {
    $desa = Illuminate\Support\Facades\DB::table('config')->first();
    echo "Nama Desa (Laravel DB): " . ($desa ? $desa->nama_desa : 'KOSONG') . "\n";
} catch (Exception $e) {
    echo "Error Laravel: " . $e->getMessage() . "\n";
}
