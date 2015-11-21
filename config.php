<?php
ini_set('display_errors',1);
// HTTP
define('HTTP_SERVER', 'http://localhost/cart/');

// HTTPS
define('HTTPS_SERVER', 'http://localhost/cart/');

// DIR
define('DIR_APPLICATION', '/var/www/html/cart/catalog/');
define('DIR_SYSTEM', '/var/www/html/cart/system/');
define('DIR_LANGUAGE', '/var/www/html/cart/catalog/language/');
define('DIR_TEMPLATE', '/var/www/html/cart/catalog/view/theme/');
define('DIR_CONFIG', '/var/www/html/cart/system/config/');
define('DIR_IMAGE', '/var/www/html/cart/image/');
define('DIR_CACHE', '/var/www/html/cart/system/cache/');
define('DIR_DOWNLOAD', '/var/www/html/cart/system/download/');
define('DIR_UPLOAD', '/var/www/html/cart/system/upload/');
define('DIR_MODIFICATION', '/var/www/html/cart/system/modification/');
define('DIR_LOGS', '/var/www/html/cart/system/logs/');

// DB
define('DB_DRIVER', 'mysqli');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'root');
define('DB_DATABASE', 'cart');
define('DB_PORT', '3306');
define('DB_PREFIX', 'oc_');
