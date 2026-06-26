<?php

session_start();

include 'pdo_obconn.php';
include 'includes/admin_access_helpers.php';
include 'includes/complaint_category_helpers.php';
require_once 'includes/record_details_layout.php';

require_system_admin($obconn);

$id = (int) base64_decode($_GET['id'] ?? '', true);

if ($id <= 0) {
    die('Invalid record.');
}

$record = complaint_category_get_by_id($obconn, $id);

if (!$record) {
    die('Complaint category not found.');
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Category Details #<?php echo (int) $record['id']; ?></title>
    <?php include 'header_css.php'; ?>
    <link href="css/orderbook_style.css" rel="stylesheet" />
    <link href="css/complaint_form.css" rel="stylesheet" />
    <link href="css/complaint_details.css" rel="stylesheet" />
    <link href="css/record_details.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>
    <div class="main-wrapper" id="mainWrapper">
        <?php include 'sidebar.php'; ?>

        <div class="content">
            <?php
            record_details_page_header(
                'Complaint Category',
                (string) $record['name'],
                'complaint_categories.php',
                'Back to List',
                'bi-tags',
                [
                    record_details_id_chip((int) $record['id']),
                    rbac_status_badge($record['status']),
                ]
            );

            record_details_card_start();

            record_details_section_start(1, 'Category Information', 'Name and current status');
            record_details_field('Name', (string) $record['name'], 'col-md-6');
            record_details_field('Status', rbac_status_badge($record['status']), 'col-md-6', false, true);
            record_details_section_end();

            record_details_section_start(2, 'Audit Trail', 'Creation and update history', true);
            record_details_field('Created By', complaint_category_created_by_label($record), 'col-md-6');
            record_details_field('Created At', rbac_format_datetime($record['created_at']), 'col-md-6');
            record_details_field('Updated At', rbac_format_datetime($record['updated_at']), 'col-md-6');
            record_details_section_end();

            record_details_card_end();
            ?>
        </div>
    </div>
</body>

</html>
