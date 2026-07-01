<?php

require_once __DIR__ . '/includes/login_helpers.php';

login_bootstrap_session();

if (empty($_SESSION['usr_name'])) {
    header('Location: login.php');
    exit;
}

require_once __DIR__ . '/pdo_obconn.php';
require_once __DIR__ . '/includes/admin_access_helpers.php';
admin_refresh_session_role($obconn);
require_once __DIR__ . '/includes/rbac_access_helpers.php';
rbac_require_page_access($obconn);
