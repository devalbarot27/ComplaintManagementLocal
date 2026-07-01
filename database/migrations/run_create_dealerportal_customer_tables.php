<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';

if (!isset($dpconn) || !($dpconn instanceof PDO)) {
    fwrite(STDERR, "dealerportal connection (\$dpconn) is not available.\n");
    exit(1);
}

$dpconn->exec(file_get_contents(__DIR__ . '/create_dealerportal_customer_tables.sql'));
$dpconn->exec(file_get_contents(__DIR__ . '/../seeds/seed_dealerportal_customer_tables.sql'));

foreach (['customer_master', 'cust_delivery_address'] as $table) {
    $count = (int) $dpconn->query("SELECT COUNT(*) FROM {$table}")->fetchColumn();
    echo "{$table}: {$count} row(s)\n";
}

$stmt = $dpconn->prepare("
    SELECT COUNT(*) AS cnt
    FROM maintdealer m
    INNER JOIN customer_master c ON TRIM(m.cuno) = TRIM(c.cuno)
    WHERE TRIM(m.cuno) = :cuno
");
$stmt->execute([':cuno' => 'CU1A03751']);
echo 'maintdealer join check (CU1A03751): ' . $stmt->fetchColumn() . " row(s)\n";
