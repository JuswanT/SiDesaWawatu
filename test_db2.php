<?php
$pdo = new PDO("mysql:host=127.0.0.1;port=3309;dbname=opensid_wawatu", "opensid", "rahasia123");
$stmt = $pdo->query("SELECT * FROM config");
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
print_r($rows);
