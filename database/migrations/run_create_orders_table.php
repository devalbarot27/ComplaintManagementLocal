<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';
$obconn->exec(file_get_contents(__DIR__ . '/create_orders_table.sql'));
echo "create_orders_table migration applied.\n";
