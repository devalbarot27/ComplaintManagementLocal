<?php
session_start();
include('pdo_obconn.php');

if (empty($_SESSION['usr_name'])) {
    header('Location: login.php');
    exit;
}

$ordno = trim((string) ($_GET['order'] ?? ''));
$cuno = trim((string) ($_GET['cuno'] ?? ''));
$reference = trim((string) ($_GET['reference'] ?? ''));

$backUrl = match ($reference) {
    'pending_order' => 'pending_order.php',
    'order_acknowledgement' => 'order_acknowledgement.php',
    default => '',
};

$formatDate = static function ($date): string {
    if ($date === null || trim((string) $date) === '') {
        return '—';
    }
    $ts = strtotime((string) $date);
    return $ts ? date('d M Y', $ts) : htmlspecialchars((string) $date, ENT_QUOTES, 'UTF-8');
};

$formatAddress = static function (array $lines): string {
    $parts = array_values(array_filter(array_map(static function ($line) {
        return trim((string) $line);
    }, $lines), static function ($line) {
        return $line !== '';
    }));

    if ($parts === []) {
        return '<span class="text-muted">—</span>';
    }

    return implode('<br>', array_map(static function ($line) {
        return htmlspecialchars($line, ENT_QUOTES, 'UTF-8');
    }, $parts));
};

$row = null;
$lineItems = [];

if ($ordno !== '' && $cuno !== '') {
    $stmt = $dpconn->prepare(
        'SELECT DISTINCT m.cuno, m.del_add, m.ord_date, m.currency, m.delterms, m.payterms, m.purno,
                c.cuname, c.st1, c.st2, c.city, c.state
         FROM maintdealer m
         INNER JOIN customer_master c ON m.cuno = c.cuno
         WHERE m.ordno = :ordno AND m.cuno = :cuno'
    );
    $stmt->bindParam(':ordno', $ordno, PDO::PARAM_STR);
    $stmt->bindParam(':cuno', $cuno, PDO::PARAM_STR);
    $stmt->execute();
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($row) {
        $itemStmt = $dpconn->prepare(
            'SELECT DISTINCT posno, item_desc, uom, qty, price, discount, excisedutyrs, salestax, earlierdate, latestdate
             FROM maintdealer
             WHERE ordno = :ordno AND cuno = :cuno
             ORDER BY posno'
        );
        $itemStmt->execute([
            ':ordno' => $ordno,
            ':cuno' => $cuno,
        ]);
        $lineItems = $itemStmt->fetchAll(PDO::FETCH_ASSOC);
    }
}

$delAddLines = ['', '', '', '', '', ''];
if ($row) {
    $delcode = trim((string) ($row['del_add'] ?? ''));
    if (strlen($delcode) === 3) {
        $addrStmt = $dpconn->prepare(
            'SELECT address1, address2, address3, address4, address5, address6
             FROM cust_delivery_address
             WHERE cuno = :cuno AND delivery_code = :delivery_code'
        );
        $addrStmt->execute([
            ':cuno' => $row['cuno'],
            ':delivery_code' => $delcode,
        ]);
        if ($addrRow = $addrStmt->fetch(PDO::FETCH_ASSOC)) {
            $delAddLines = [
                $addrRow['address1'] ?? '',
                $addrRow['address2'] ?? '',
                $addrRow['address3'] ?? '',
                $addrRow['address4'] ?? '',
                $addrRow['address5'] ?? '',
                $addrRow['address6'] ?? '',
            ];
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dealer - Order Details</title>
    <?php include('header_css.php'); ?>
    <link href="css/order_acknowledge_style.css" rel="stylesheet" />
    <link href="css/order_details.css" rel="stylesheet" />
    <link href="css/table_style.css" rel="stylesheet" />
    <link href="css/order_data.css" rel="stylesheet" />
</head>

<body>
    <div class="main-wrapper order-data-page" id="mainWrapper">
        <?php include('sidebar.php'); ?>

        <div class="content">
            <?php if (!$row): ?>
                <div class="details-card empty-state-card">
                    <i class="bi bi-file-earmark-x d-block"></i>
                    <h5>Order not found</h5>
                    <p>We could not load details for this order. It may have been removed or the link is invalid.</p>
                    <?php if ($backUrl !== ''): ?>
                        <a href="<?= htmlspecialchars($backUrl, ENT_QUOTES, 'UTF-8') ?>" class="btn btn-outline-dark btn-sm">
                            Go back
                        </a>
                    <?php else: ?>
                        <button type="button" class="btn btn-outline-dark btn-sm" onclick="history.back()">
                             Go back
                        </button>
                    <?php endif; ?>
                </div>
            <?php else: ?>
                <div class="details-header">
                    <div class="details-left">
                        <?php if ($backUrl !== ''): ?>
                            <a href="<?= htmlspecialchars($backUrl, ENT_QUOTES, 'UTF-8') ?>" class="back-btn" title="Go back">
                                <i class="bi bi-arrow-left"></i>
                            </a>
                        <?php else: ?>
                            <button type="button" class="back-btn border-0" onclick="history.back()" title="Go back">
                                <i class="bi bi-arrow-left"></i>
                            </button>
                        <?php endif; ?>

                        <div>
                            <div class="order-main-title">Order Acknowledgement</div>
                            <div class="order-subtitle">ELGI Equipments Ltd</div>
                            <div class="order-meta-row">
                                <span class="meta-chip">
                                    <i class="bi bi-hash"></i>
                                    AO <strong><?= htmlspecialchars($ordno, ENT_QUOTES, 'UTF-8') ?></strong>
                                </span>
                                <span class="meta-chip">
                                    <i class="bi bi-calendar3"></i>
                                    <strong><?= $formatDate($row['ord_date'] ?? '') ?></strong>
                                </span>
                                <?php if (trim((string) ($row['purno'] ?? '')) !== ''): ?>
                                    <span class="meta-chip">
                                        <i class="bi bi-receipt"></i>
                                        PO <strong><?= htmlspecialchars(trim((string) $row['purno']), ENT_QUOTES, 'UTF-8') ?></strong>
                                    </span>
                                <?php endif; ?>
                                <?php if (trim((string) ($row['currency'] ?? '')) !== ''): ?>
                                    <span class="meta-chip">
                                        <i class="bi bi-currency-exchange"></i>
                                        <strong><?= htmlspecialchars(trim((string) $row['currency']), ENT_QUOTES, 'UTF-8') ?></strong>
                                    </span>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>

                    <div class="details-right">
                        <span class="type-badge">
                            <?= count($lineItems) ?> line item<?= count($lineItems) === 1 ? '' : 's' ?>
                        </span>
                    </div>
                </div>

                <div class="info-grid info-grid--two">
                    <div class="details-card">
                        <div class="section-title">
                            <i class="bi bi-person-vcard"></i>
                            Customer &amp; Terms
                        </div>
                        <div class="info-list">
                            <div class="info-row">
                                <span>Customer</span>
                                <strong>
                                    <?= htmlspecialchars(trim((string) ($row['cuname'] ?? '')), ENT_QUOTES, 'UTF-8') ?>
                                    [<?= htmlspecialchars(trim((string) ($row['cuno'] ?? '')), ENT_QUOTES, 'UTF-8') ?>]
                                </strong>
                            </div>
                            <div class="info-row">
                                <span>PO Number</span>
                                <strong><?= trim((string) ($row['purno'] ?? '')) !== '' ? htmlspecialchars(trim((string) $row['purno']), ENT_QUOTES, 'UTF-8') : '—' ?></strong>
                            </div>
                            <div class="info-row">
                                <span>Payment Terms</span>
                                <strong><?= trim((string) ($row['payterms'] ?? '')) !== '' ? htmlspecialchars(trim((string) $row['payterms']), ENT_QUOTES, 'UTF-8') : '—' ?></strong>
                            </div>
                            <div class="info-row">
                                <span>Delivery Terms</span>
                                <strong><?= trim((string) ($row['delterms'] ?? '')) !== '' ? htmlspecialchars(trim((string) $row['delterms']), ENT_QUOTES, 'UTF-8') : '—' ?></strong>
                            </div>
                        </div>
                    </div>

                    <div class="details-card">
                        <div class="section-title">
                            <i class="bi bi-geo-alt"></i>
                            Addresses
                        </div>
                        <div class="address-box" style="margin-top: 0; border-top: none; padding-top: 0;">
                            <div class="address-title">Invoice Address</div>
                            <div class="address-text">
                                <?= $formatAddress([
                                    $row['cuname'] ?? '',
                                    $row['st1'] ?? '',
                                    $row['st2'] ?? '',
                                    $row['city'] ?? '',
                                    $row['state'] ?? '',
                                ]) ?>
                            </div>
                        </div>
                        <div class="address-box">
                            <div class="address-title">Delivery Address</div>
                            <div class="address-text">
                                <?= $formatAddress($delAddLines) ?>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="details-card line-items-card">
                    <div class="section-title">
                        <i class="bi bi-list-ul"></i>
                        Order Line Details
                    </div>

                    <div class="table-responsive">
                        <table class="booking-table line-items-table mb-0">
                            <thead>
                                <tr>
                                    <th rowspan="2">Position</th>
                                    <th rowspan="2">Item Description</th>
                                    <th rowspan="2">UOM</th>
                                    <th rowspan="2">Qty</th>
                                    <th rowspan="2">Price / Unit</th>
                                    <th rowspan="2">Discount (%)</th>
                                    <th colspan="2">Duty &amp; Taxes / Unit</th>
                                    <th colspan="2">Planned Delivery Date</th>
                                </tr>
                                <tr>
                                    <th>Excise Duty</th>
                                    <th>Sales Tax</th>
                                    <th>Earliest</th>
                                    <th>Latest</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($lineItems === []): ?>
                                    <tr>
                                        <td colspan="10" class="text-center text-muted py-4">No line items found for this order.</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($lineItems as $item): ?>
                                        <tr>
                                            <td class="text-center"><?= htmlspecialchars((string) ($item['posno'] ?? ''), ENT_QUOTES, 'UTF-8') ?></td>
                                            <td class="item-desc"><?= htmlspecialchars((string) ($item['item_desc'] ?? ''), ENT_QUOTES, 'UTF-8') ?></td>
                                            <td class="text-center"><?= htmlspecialchars((string) ($item['uom'] ?? ''), ENT_QUOTES, 'UTF-8') ?></td>
                                            <td class="text-end"><?= number_format((float) ($item['qty'] ?? 0), 2) ?></td>
                                            <td class="text-end"><?= number_format((float) ($item['price'] ?? 0), 2) ?></td>
                                            <td class="text-end"><?= number_format((float) ($item['discount'] ?? 0), 2) ?></td>
                                            <td class="text-end"><?= number_format((float) ($item['excisedutyrs'] ?? 0), 2) ?></td>
                                            <td class="text-end"><?= number_format((float) ($item['salestax'] ?? 0), 2) ?></td>
                                            <td class="text-center"><?= $formatDate($item['earlierdate'] ?? '') ?></td>
                                            <td class="text-center"><?= $formatDate($item['latestdate'] ?? '') ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            <?php endif; ?>
        </div>
    </div>
</body>

</html>
<?php include('script_js.php'); ?>
