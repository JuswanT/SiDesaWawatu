#!/bin/bash
echo "======================================================"
echo "  DIAGNOSTIK MULTISITE & DATABASE OPENSID (FINAL)"
echo "======================================================"

# Kita gunakan PDO dari dalam opensid-app untuk mengecek database!
docker exec opensid-app php -r '
$folders = glob("/var/www/html/desa_*", GLOB_ONLYDIR);
$db_pass = "network2024"; // Sesuai dengan test_db.php sebelumnya

foreach($folders as $dir) {
    $desa = basename($dir);
    echo "Folder: $desa\n";
    $db_file = $dir . "/config/database.php";
    if (file_exists($db_file)) {
        $c = file_get_contents($db_file);
        if (preg_match("/\\\$db\\[\x27default\x27\\]\\[\x27database\x27\\]\s*=\s*\x27(.*?)\x27;/", $c, $m)) {
            $db_name = $m[1];
            echo "  -> Terkoneksi ke Database : $db_name\n";
            
            try {
                $pdo = new PDO("mysql:host=db;port=3306;dbname=$db_name", "opensid", $db_pass);
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                
                $stmt = $pdo->query("SELECT nama_desa FROM config LIMIT 1");
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if ($row && !empty($row["nama_desa"])) {
                    echo "  -> Identitas Nama Desa    : " . $row["nama_desa"] . "\n";
                } else {
                    echo "  ❌ Tabel config kosong atau tidak ada data nama_desa!\n";
                }
            } catch (PDOException $e) {
                echo "  ❌ Gagal koneksi ke database $db_name: " . $e->getMessage() . "\n";
            }
        } else {
            echo "  ❌ String konfigurasi database tidak valid di database.php\n";
        }
    } else {
        echo "  ❌ File config/database.php TIDAK ADA!\n";
    }
    echo "\n";
}
'
