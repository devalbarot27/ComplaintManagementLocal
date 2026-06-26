<?php

include('pdo_obconn.php');

header("Content-Type: application/json");

$xml = file_get_contents("php://input");

libxml_use_internal_errors(true);

$doc = simplexml_load_string($xml);

if ($doc === false) {

    $errors = [];

    foreach (libxml_get_errors() as $error) {
        $errors[] = trim($error->message);
    }

    echo json_encode([
        "status" => 400,
        "message" => "Invalid XML",
        "errors" => $errors
    ]);
    exit;
}

$namespaces = $doc->getNamespaces(true);
$ns = $namespaces[''];

$dataArea = $doc->children($ns)->DataArea;
$ack = $dataArea->ElgiSalesOrderAckXML;

$orderNumber = trim((string)$ack->ordernumber);
$elgiAoNumber = trim((string)$ack->elgi_aonumber);
$orderDate = trim((string)$ack->elgi_commitmentdate);

$chkData = $obconn->prepare("
    SELECT 1
    FROM plexecom_customer_units
    WHERE refno = :refno
");
$chkData->bindParam(":refno", $orderNumber);
$chkData->execute();

if ($chkData->rowCount() > 0) {

    $update = $obconn->prepare("
        UPDATE plexecom_customer_units
        SET order_number = :orderNumber,
        order_date = :orderDate
        WHERE refno = :refno
    ");

    $update->bindParam(":orderNumber", $elgiAoNumber);
    $update->bindParam(":orderDate", $orderDate);
    $update->bindParam(":refno", $orderNumber);
    $update->execute();

    echo json_encode([
        "status" => 200,
        "message" => "Updated Successfully"
    ]);
    exit;
}

echo json_encode([
    "status" => 404,
    "message" => "Reference number not found"
]);