<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';

if (!isset($dpconn) || !($dpconn instanceof PDO)) {
    fwrite(STDERR, "dealerportal connection (\$dpconn) is not available.\n");
    exit(1);
}

$dpconn->exec(file_get_contents(__DIR__ . '/create_dealerportal_commitment_lrdetails.sql'));
$dpconn->exec(file_get_contents(__DIR__ . '/../seeds/seed_dealerportal_commitment_lrdetails.sql'));

foreach (['tbl_commitment', 'lrdetails'] as $table) {
    $count = (int) $dpconn->query("SELECT COUNT(*) FROM {$table}")->fetchColumn();
    echo "{$table}: {$count} row(s)\n";
}
