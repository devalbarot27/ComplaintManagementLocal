<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';
$obconn->exec(file_get_contents(__DIR__ . '/add_user_sales_coordinator.sql'));
echo "Added user_master.sales_coordinator_id.\n";
