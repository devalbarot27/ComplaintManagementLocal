<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';
$obconn->exec(file_get_contents(__DIR__ . '/drop_permissions_ordering.sql'));
echo "Dropped permissions.ordering.\n";
