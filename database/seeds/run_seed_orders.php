<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';

$obconn->exec(file_get_contents(__DIR__ . '/../migrations/create_orders_table.sql'));
$obconn->exec(file_get_contents(__DIR__ . '/seed_orders.sql'));

$count = (int) $obconn->query('SELECT COUNT(*) FROM orders WHERE deleted_at IS NULL')->fetchColumn();
echo "Orders table ready. Active records: {$count}\n";
