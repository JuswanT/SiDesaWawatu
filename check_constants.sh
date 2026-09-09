docker exec opensid-app php -r '
$c = file_get_contents("/var/www/html/donjo-app/config/constants.php");
$start = strpos($c, "\$host = \$_SERVER[\"HTTP_HOST\"] ?? \"\";");
if ($start === false) { $start = strpos($c, "\$host = \$_SERVER[\x27HTTP_HOST\x27]"); }
$end = strpos($c, "// Fallback to default");
if ($start !== false && $end !== false) {
    echo substr($c, $start, $end - $start);
} else {
    echo "Could not find block";
}
'
