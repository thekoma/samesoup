
<?php
defined('ENABLE_URL_REWRITE') or define('ENABLE_URL_REWRITE', true);
defined('LOG_DRIVER') or define('LOG_DRIVER', 'system');
define('AWS_S3_PREFIX', '');
define('AWS_S3_REGION', 'us-east-1');
define('AWS_S3_OPTIONS', json_encode(['version' => 'latest', 'endpoint' => 'https://storage.googleapis.com', 'use_path_style_endpoint' => true]));
define('DB_DRIVER', 'postgres');

