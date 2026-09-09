<?php
// Letakkan ini di folder OpenSID
define('DEBUG_DESA_MODE', true);
require 'index.php';

echo "<h1>DIAGNOSTIK FRONTEND</h1>";
echo "Domain: " . $_SERVER['HTTP_HOST'] . "<br>";
echo "Folder Desa: " . LOKASI_CONFIG_DESA . "<br>";
echo "Database CI: " . $db['default']['database'] . "<br>";

$desa = \Illuminate\Support\Facades\DB::table('config')->first();
echo "Database Laravel: " . config('database.connections.mysql.database') . "<br>";
echo "Nama Desa (Laravel): " . ($desa ? $desa->nama_desa : 'KOSONG') . "<br>";

// Cek hardcode di session
echo "<pre>Session CodeIgniter: \n";
print_r($_SESSION);
echo "</pre>";

die();
