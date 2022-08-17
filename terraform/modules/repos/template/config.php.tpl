<?php
defined('ENABLE_URL_REWRITE') or define('ENABLE_URL_REWRITE', true);
defined('LOG_DRIVER') or define('LOG_DRIVER', 'system');
define('PLUGIN_INSTALLER', true);
define('DB_RUN_MIGRATIONS', true);
define('AWS_S3_PREFIX', '');
define('AWS_S3_REGION', 'us-east-1');
define('AWS_S3_OPTIONS', json_encode(['version' => 'latest', 'endpoint' => 'https://storage.googleapis.com', 'use_path_style_endpoint' => true]));
define('DB_DRIVER', 'postgres');

// Database driver: sqlite, mysql or postgres (sqlite by default)
define('DB_DRIVER', 'postgres');

// Mysql/Postgres username
define('DB_USERNAME', '${db_user}');

// Mysql/Postgres password
define('DB_PASSWORD', '${db_password}');

// Mysql/Postgres hostname
define('DB_HOSTNAME', '${db_hostname}');

// Mysql/Postgres database name
define('DB_NAME', '${db_name}');


define('AWS_KEY', '${aws_key}');
define('AWS_SECRET', '${aws_secret}');
define('AWS_S3_BUCKET', '${aws_bucket}');

//EOF