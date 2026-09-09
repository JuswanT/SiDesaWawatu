<?php
try {
    $pdo = new PDO("mysql:host=localhost;port=3306;dbname=opensid", "opensid", "opensid123");
    $stmt = $pdo->query("SELECT count(*) FROM config");
    echo "Jumlah row di opensid: " . $stmt->fetchColumn() . "\n";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
