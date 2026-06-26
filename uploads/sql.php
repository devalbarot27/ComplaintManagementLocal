<?php
include '../pdo_obconn.php';


/*
$stmt = $obconn->prepare("SELECT * FROM tbl_vayu_orders_header LIMIT 500");

if (!$stmt->execute()) {
    print_r($stmt->errorInfo());
    die();
}

$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "<pre>";
print_r($result);
die();
*/


/* 1. Create industry_segments */


/*
$stmt = $obconn->prepare("
ALTER TABLE complaint_closures
    ADD COLUMN IF NOT EXISTS customer_feedback VARCHAR(100);");
$stmt->execute();
*/



try {
    // 1. Get table structure
    $stmt = $dpconn->prepare("
        SELECT 
            column_name,
            data_type,
            character_maximum_length,
            is_nullable,
            column_default
        FROM information_schema.columns
        WHERE table_name = 'pendingordersnew'
        ORDER BY ordinal_position
    ");
    
    $stmt->execute();
    $structure = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // 2. Get sample data
    $stmt = $dpconn->prepare("
        SELECT *
        FROM pendingordersnew
        LIMIT 10
    ");

    $stmt->execute();
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // 3. Merge output
    echo "<pre>";
    print_r([
        "structure" => $structure,
        "data" => $data
    ]);

} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
die();

?>