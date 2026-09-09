#!/bin/bash
docker exec opensid-app php -r "
// we just dump how constants parses APP_URL
\$_SERVER['HTTP_HOST'] = 'desawawatu.web.id';
\$_SERVER['SCRIPT_NAME'] = '/index.php';
// if index.php patch is active, $_SERVER['HTTPS'] is 'on'
if(file_exists('/var/www/html/index.php')) {
    \$c = file_get_contents('/var/www/html/index.php');
    if (strpos(\$c, '\$_SERVER[\"HTTPS\"]=\"on\"') !== false || strpos(\$c, '\$_SERVER[\'HTTPS\']=\"on\"') !== false) {
        \$_SERVER['HTTPS'] = 'on';
    }
}
define('FORCE_HTTPS', false);
\$app_url = (((isset(\$_SERVER['HTTPS']) && \$_SERVER['HTTPS'] == 'on') || FORCE_HTTPS == true) ? 'https' : 'http') . '://' . (\$_SERVER['HTTP_HOST'] ?? '') . str_replace(basename(\$_SERVER['SCRIPT_NAME']), '', \$_SERVER['SCRIPT_NAME']);
echo 'TEST APP_URL = ' . \$app_url . \"\n\";
"
