<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';

$obconn->exec(file_get_contents(__DIR__ . '/create_order_lookup_tables.sql'));
$obconn->exec(file_get_contents(__DIR__ . '/../seeds/seed_order_lookup_tables.sql'));

foreach ([
    'tbl_vayu_delivery_term',
    'tbl_vayu_order_category',
    'spp_payterm_master',
    'transporter_master',
] as $table) {
    $count = (int) $obconn->query("SELECT COUNT(*) FROM {$table}")->fetchColumn();
    echo "{$table}: {$count} row(s)\n";
}
