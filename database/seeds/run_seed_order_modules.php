<?php
require dirname(__DIR__, 2) . '/pdo_obconn.php';

$obconn->exec(file_get_contents(__DIR__ . '/../migrations/create_order_booking_cart_tables.sql'));
$obconn->exec(file_get_contents(__DIR__ . '/seed_order_module_complaint_management.sql'));

if (!isset($dpconn) || !($dpconn instanceof PDO)) {
    fwrite(STDERR, "dealerportal connection (\$dpconn) is not available.\n");
    exit(1);
}

$dpconn->exec(file_get_contents(__DIR__ . '/seed_order_module_dealerportal.sql'));

$tablesOb = [
    'orders',
    'plexecom_customer_units',
    'tbl_vayu_item_master',
    'tbl_vayu_cartitems',
    'tbl_vayu_orders_line',
    'tbl_vayu_orders_header',
    'sales_orders',
    'tbl_vayu_order_category',
    'spp_payterm_master',
    'transporter_master',
];

$tablesDp = [
    'pendingordersnew',
    'tbl_commitment',
    'maintdealer',
    'despatch',
    'lr_details',
    'lrdetails',
];

echo "complaint_management (CU1A03751 / demo rows):\n";
foreach ($tablesOb as $table) {
    try {
        $total = (int) $obconn->query("SELECT COUNT(*) FROM {$table}")->fetchColumn();
        $demo = 0;
        if ($table === 'plexecom_customer_units') {
            $demo = (int) $obconn->query("SELECT COUNT(*) FROM {$table} WHERE cuno = 'CU1A03751'")->fetchColumn();
        } elseif ($table === 'tbl_vayu_cartitems') {
            $demo = (int) $obconn->query("SELECT COUNT(*) FROM {$table} WHERE created_by = 'CU1A03751'")->fetchColumn();
        } elseif ($table === 'tbl_vayu_orders_header') {
            $demo = (int) $obconn->query("SELECT COUNT(*) FROM {$table} WHERE created_by = 'CU1A03751'")->fetchColumn();
        }
        echo sprintf("  %-28s total=%d", $table, $total);
        if ($demo > 0) {
            echo " demo={$demo}";
        }
        echo "\n";
    } catch (Throwable $e) {
        echo "  {$table}: ERR {$e->getMessage()}\n";
    }
}

echo "\ndealerportal (CU1A03751):\n";
foreach ($tablesDp as $table) {
    try {
        $total = (int) $dpconn->query("SELECT COUNT(*) FROM {$table}")->fetchColumn();
        $demo = 0;
        if (in_array($table, ['pendingordersnew', 'maintdealer', 'despatch', 'lrdetails'], true)) {
            $demo = (int) $dpconn->query("SELECT COUNT(*) FROM {$table} WHERE TRIM(cuno) = 'CU1A03751'")->fetchColumn();
        } elseif ($table === 'tbl_commitment') {
            $demo = (int) $dpconn->query("SELECT COUNT(*) FROM {$table} WHERE orderno LIKE '204070%'")->fetchColumn();
        } elseif ($table === 'lr_details') {
            $demo = (int) $dpconn->query("SELECT COUNT(*) FROM {$table} WHERE invref IN ('701','702','703','704','705','706')")->fetchColumn();
        }
        echo sprintf("  %-28s total=%d demo=%d\n", $table, $total, $demo);
    } catch (Throwable $e) {
        echo "  {$table}: ERR {$e->getMessage()}\n";
    }
}

echo "\nOrder module seed complete.\n";
