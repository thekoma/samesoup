
<?php


defined('ENABLE_URL_REWRITE') or define('ENABLE_URL_REWRITE', true);
defined('LOG_DRIVER') or define('LOG_DRIVER', 'system');

define('AWS_KEY', getenv("AWS_KEY"));
define('AWS_SECRET', getenv("AWS_SECRET"));
define('AWS_S3_BUCKET', getenv("AWS_S3_BUCKET"));
define('AWS_S3_PREFIX', '');

// Set the region of your bucket
define('AWS_S3_REGION', 'us-east-1');

// Use AWS_S3_OPTIONS to configure custom end-point, like Minio
define('AWS_S3_OPTIONS', json_encode(['version' => 'latest', 'endpoint' => 'https://storage.googleapis.com', 'use_path_style_endpoint' => true]));
