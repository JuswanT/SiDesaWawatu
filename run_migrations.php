<?php
define('FCPATH', __DIR__ . DIRECTORY_SEPARATOR);
require 'vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

app()->configure('database');
$db = new \App\Libraries\Database();
$db->setShowProgress(1);

$doesntHaveMigrasiConfigId = ! \Illuminate\Support\Facades\Schema::hasColumn('migrasi', 'config_id');
\App\Models\Migrasi::when($doesntHaveMigrasiConfigId, static fn ($q) => $q->withoutConfigId())->whereNotNull('id')->delete();

$db->migrateDatabase(true);
echo "<br>Migrations finished successfully.";
