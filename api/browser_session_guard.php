<?php

require_once dirname(__DIR__) . '/includes/login_helpers.php';

login_bootstrap_session();

header('Content-Type: application/json');

$keepSession = login_validate_browser_session();

echo json_encode([
    'logout' => !$keepSession,
]);
