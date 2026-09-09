<?php
echo "HTTP_HOST: " . ($_SERVER['HTTP_HOST'] ?? 'NOT SET') . "\n";
echo "HTTP_X_FORWARDED_HOST: " . ($_SERVER['HTTP_X_FORWARDED_HOST'] ?? 'NOT SET') . "\n";
