<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';

$sql = file_get_contents(__DIR__ . '/add_module_permission_ordering.sql');
$obconn->exec($sql);
echo "Migration applied successfully.\n";
