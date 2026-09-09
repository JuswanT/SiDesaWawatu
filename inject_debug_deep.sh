#!/bin/bash
echo "Menyuntikkan diagnostik dalam ke index.php..."
docker exec opensid-app php -r '
$f = "/var/www/html/index.php";
$c = file_get_contents($f);

// Bersihkan injeksi sebelumnya jika ada
$c = preg_replace("/\/\/ --- INJEKSI DIAGNOSTIK.*?\/\/ --- END INJEKSI ---/s", "", $c);

// Buat injeksi baru di bagian paling bawah
$injeksi = "
// --- INJEKSI DIAGNOSTIK DALAM ---
if (isset(\$_GET[\x27debug_multisite\x27])) {
    echo \x27<div style=\"padding:20px; background:#222; color:#0f0; font-family:monospace; font-size:16px;\">\x27;
    echo \x27<h3>🔍 DIAGNOSTIK MENDALAM OPENSID</h3>\x27;
    echo \x27Host: \x27 . \$_SERVER[\x27HTTP_HOST\x27] . \x27<br>\x27;
    echo \x27Folder Config: \x27 . (defined(\x27LOKASI_CONFIG_DESA\x27) ? LOKASI_CONFIG_DESA : \x27UNDEFINED\x27) . \x27<br>\x27;
    
    global \$db;
    echo \x27DB CodeIgniter: \x27 . (isset(\$db[\x27default\x27][\x27database\x27]) ? \$db[\x27default\x27][\x27database\x27] : \x27N/A\x27) . \x27<br>\x27;
    
    if (class_exists(\x27Illuminate\Support\Facades\DB\x27)) {
        try {
            \$dbName = config(\x27database.connections.mysql.database\x27);
            echo \x27DB Laravel: \x27 . \$dbName . \x27<br>\x27;
            
            \$desa = \Illuminate\Support\Facades\DB::table(\x27config\x27)->first();
            echo \x27Nama Desa (Dari Laravel DB): \x27 . (\$desa ? \$desa->nama_desa : \x27KOSONG\x27) . \x27<br>\x27;
        } catch (Exception \$e) {
            echo \x27Error Laravel: \x27 . \$e->getMessage() . \x27<br>\x27;
        }
    } else {
        echo \x27Laravel belum dimuat (Class DB tidak ada).<br>\x27;
    }
    echo \x27</div>\x27;
    exit;
}
// --- END INJEKSI ---
";

$c .= $injeksi;
file_put_contents($f, $c);
echo "Berhasil! Silakan buka web dengan parameter ?debug_multisite=1";
'
