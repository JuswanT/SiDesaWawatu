<?php
require 'vendor/autoload.php';
$funcs = get_defined_functions();
foreach ($funcs['user'] as $f) {
    if (strpos($f, 'getroutes') !== false) {
        $r = new ReflectionFunction($f);
        echo $r->getFileName() . ':' . $r->getStartLine() . "\n";
    }
}
