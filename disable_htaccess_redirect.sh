#!/bin/bash
docker exec opensid-app php -r '
$f = "/var/www/html/.htaccess";
$c = file_get_contents($f);
$c = str_replace("RewriteCond %{HTTPS} !=on", "# RewriteCond %{HTTPS} !=on", $c);
$c = str_replace("RewriteCond %{HTTP:X-Forwarded-Proto} !https [NC]", "# RewriteCond %{HTTP:X-Forwarded-Proto} !https [NC]", $c);
$c = str_replace("RewriteCond %{HTTP:CF-Visitor} !^{\"scheme\":\"https\"}$ [NC]", "# RewriteCond %{HTTP:CF-Visitor} !^{\"scheme\":\"https\"}$ [NC]", $c);
$c = str_replace("RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]", "# RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]", $c);
file_put_contents($f, $c);
echo "✅ Redirect HTTPS di .htaccess berhasil dinonaktifkan (karena Cloudflare sudah menanganinya)!\n";
'
