<?php
require_once __DIR__ . '/includes/login_helpers.php';

login_bootstrap_session();
login_destroy_session();

header('Location: login.php');
exit;
