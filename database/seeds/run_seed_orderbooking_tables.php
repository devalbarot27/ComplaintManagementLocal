<?php

declare(strict_types=1);

require dirname(__DIR__, 2) . '/pdo_obconn.php';

$sqlFile = __DIR__ . '/seed_orderbooking_tables.sql';
$sql = file_get_contents($sqlFile);

if ($sql === false) {
    fwrite(STDERR, "Unable to read {$sqlFile}\n");
    exit(1);
}

$obconn->exec($sql);
echo "Applied seed_orderbooking_tables.sql\n";
