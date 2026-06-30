-- complaint_management: sample data for order modules (6 rows per table where applicable).
-- Demo customer code matches orderClass.php filters: CU1A03751

-- Lookup tables (top up to 6+ rows)
INSERT INTO tbl_vayu_order_category (id, order_category, status) VALUES
    (4, 'Spare Parts Order', 1),
    (5, 'Service Parts Order', 1),
    (6, 'Warranty Replacement', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO spp_payterm_master (pay_code, pay_desc, dpst, valid) VALUES
    ('003', '45 Days Credit', '90092', 'Y'),
    ('004', '90 Days Credit', '90092', 'Y'),
    ('005', 'Against Delivery', '90092', 'Y')
ON CONFLICT (pay_code, dpst) DO NOTHING;

INSERT INTO transporter_master (trans_code, trans_name) VALUES
    ('T03', 'Blue Dart Express'),
    ('T04', 'Gati Logistics'),
    ('T05', 'VRL Transport')
ON CONFLICT (trans_code) DO NOTHING;

-- Order booking item master (6 items)
INSERT INTO tbl_vayu_item_master (item_code, item_description, status)
SELECT v.item_code, v.item_description, v.status
FROM (VALUES
    ('SP-10001', 'Air Filter Element AF-200', 1),
    ('SP-10002', 'Oil Separator OS-350', 1),
    ('SP-10003', 'Belt Set BS-110', 1),
    ('SP-10004', 'Pressure Switch PS-45', 1),
    ('SP-10005', 'Drain Valve DV-22', 1),
    ('SP-10006', 'Coolant Hose CH-88', 1)
) AS v(item_code, item_description, status)
WHERE NOT EXISTS (
    SELECT 1 FROM tbl_vayu_item_master t WHERE t.item_code = v.item_code
);

-- Cart items for demo user (6 rows, status 0 = active cart)
INSERT INTO tbl_vayu_cartitems (item_code, item_name, price, qty, total_amount, created_by, status)
SELECT v.item_code, v.item_name, v.price, v.qty, v.total_amount, 'CU1A03751', 0
FROM (VALUES
    ('SP-10001', 'Air Filter Element AF-200', 1250.00, 2, 2500.00),
    ('SP-10002', 'Oil Separator OS-350', 4800.00, 1, 4800.00),
    ('SP-10003', 'Belt Set BS-110', 890.00, 3, 2670.00),
    ('SP-10004', 'Pressure Switch PS-45', 2100.00, 1, 2100.00),
    ('SP-10005', 'Drain Valve DV-22', 650.00, 4, 2600.00),
    ('SP-10006', 'Coolant Hose CH-88', 420.00, 2, 840.00)
) AS v(item_code, item_name, price, qty, total_amount)
WHERE NOT EXISTS (
    SELECT 1 FROM tbl_vayu_cartitems c
    WHERE c.created_by = 'CU1A03751' AND c.item_code = v.item_code AND c.status = 0
);

-- Recent orders (plexecom_customer_units) — 6 rows for CU1A03751
INSERT INTO plexecom_customer_units (
    cuno, cuname, refno, order_number, indent_date, indent_number,
    tplcode, tpldesc, qty, price, delterms_code, indent_category,
    paycode, transporter, deladdr, areacode, dpst, status, pono
)
SELECT
    'CU1A03751', v.cuname, v.refno, v.order_number, v.indent_date::date, v.indent_number,
    v.tplcode, v.tpldesc, v.qty, v.price, v.delterms_code, v.indent_category,
    v.paycode, v.transporter, v.deladdr, v.areacode, v.dpst, 'A', v.pono
FROM (VALUES
    ('Demo Industries Pvt Ltd', 'E/DEMO/260001', '204080001', '2026-03-01', 'IND/26/0001', '008979028', 'TEMP TRANSMITTER (0-150 DEG C)', 1, 8925.00, '004', 1, '660', 'T50', 'Demo Industries, Mumbai', '021', '90079', 'PO-DEMO-001'),
    ('Demo Industries Pvt Ltd', 'E/DEMO/260002', '204080002', '2026-03-05', 'IND/26/0002', '220317590', 'VALVE ASSY, PR REG, 1/4 NPT', 2, 4806.75, '004', 1, '660', 'T01', 'Demo Industries, Mumbai', '021', '90079', 'PO-DEMO-002'),
    ('Demo Industries Pvt Ltd', 'E/DEMO/260003', '204080003', '2026-03-08', 'IND/26/0003', 'S019360', 'EG 45-8.5 DM 400V/50HZ', 1, 976424.00, '541', 2, '001', 'T02', 'Demo Plant, Pune', '031', '90079', 'PO-DEMO-003'),
    ('Demo Industries Pvt Ltd', 'E/DEMO/260004', '204080004', '2026-03-12', 'IND/26/0004', 'SP-10001', 'Air Filter Element AF-200', 5, 1250.00, '122', 4, '002', 'T03', 'Demo Warehouse, Chennai', '041', '90079', 'PO-DEMO-004'),
    ('Demo Industries Pvt Ltd', 'E/DEMO/260005', '204080005', '2026-03-15', 'IND/26/0005', 'SP-10003', 'Belt Set BS-110', 10, 890.00, '010', 4, '003', 'T04', 'Demo Site, Hyderabad', '051', '90079', 'PO-DEMO-005'),
    ('Demo Industries Pvt Ltd', 'E/DEMO/260006', '204080006', '2026-03-18', 'IND/26/0006', 'SP-10005', 'Drain Valve DV-22', 8, 650.00, '546', 5, '004', 'T05', 'Demo Service Center, Delhi', '011', '90079', 'PO-DEMO-006')
) AS v(cuname, refno, order_number, indent_date, indent_number, tplcode, tpldesc, qty, price, delterms_code, indent_category, paycode, transporter, deladdr, areacode, dpst, pono)
WHERE NOT EXISTS (
    SELECT 1 FROM plexecom_customer_units p WHERE p.refno = v.refno
);

-- Order acknowledgement line items (6 orders x 1 line each)
INSERT INTO tbl_vayu_orders_line (order_no, item_code, item_description, quantity, price, total_amount)
SELECT v.order_no, v.item_code, v.item_description, v.quantity, v.price, v.total_amount
FROM (VALUES
    ('301001001', 'SP-10001', 'Air Filter Element AF-200', 2, 1250.00, 2500.00),
    ('301001002', 'SP-10002', 'Oil Separator OS-350', 1, 4800.00, 4800.00),
    ('301001003', 'SP-10003', 'Belt Set BS-110', 3, 890.00, 2670.00),
    ('301001004', 'SP-10004', 'Pressure Switch PS-45', 1, 2100.00, 2100.00),
    ('301001005', 'SP-10005', 'Drain Valve DV-22', 4, 650.00, 2600.00),
    ('301001006', 'SP-10006', 'Coolant Hose CH-88', 2, 420.00, 840.00)
) AS v(order_no, item_code, item_description, quantity, price, total_amount)
WHERE NOT EXISTS (
    SELECT 1 FROM tbl_vayu_orders_line l WHERE l.order_no = v.order_no AND l.item_code = v.item_code
);

-- Orders module table (1 extra row if only 5 exist; safe if 6 already present)
INSERT INTO orders (
    order_id, order_year, sequence_number,
    fab_number, customer_name, invoice_date,
    dealer_name, machine_model, created_by
)
SELECT v.order_id, v.order_year, v.sequence_number, v.fab_number, v.customer_name,
       v.invoice_date::date, v.dealer_name, v.machine_model, v.created_by
FROM (VALUES
    ('ORD/2026/00007', 2026, 7, 'FAB-2026-007', 'Demo Industries Pvt Ltd', '2026-03-25', 'Mumbai Dealer', 'EG-77', 1)
) AS v(order_id, order_year, sequence_number, fab_number, customer_name, invoice_date, dealer_name, machine_model, created_by)
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.order_id = v.order_id AND o.deleted_at IS NULL
);

-- sales_orders (6th record)
INSERT INTO sales_orders (order_id, fab_number, customer_name, invoice_date, dealer_name, machine_model)
SELECT v.order_id, v.fab_number, v.customer_name, v.invoice_date::date, v.dealer_name, v.machine_model
FROM (VALUES
    ('ORD-10006', '1000000006', 'Demo Industries Pvt Ltd', '2024-06-01', 'Demo Dealer', 'Model X600')
) AS v(order_id, fab_number, customer_name, invoice_date, dealer_name, machine_model)
WHERE NOT EXISTS (
    SELECT 1 FROM sales_orders s WHERE s.order_id = v.order_id
);

-- Order headers for booking history (6 rows for demo user)
INSERT INTO tbl_vayu_orders_header (
    order_no, created_by, order_category, dealer_address, delivery_term, payment_term, transporter
)
SELECT v.order_no, 'CU1A03751', v.order_category, v.dealer_address, v.delivery_term, v.payment_term, v.transporter
FROM (VALUES
    ('ORD/DEMO/000001', 'Standard Order', 'Mumbai Dealer Hub', 'PAID - DOOR DELY CC ATTACHED', '100% Advance', 'Sample Transporter'),
    ('ORD/DEMO/000002', 'Special Order', 'Pune Dealer Hub', 'PAID - DOOR DELIVERY (FTL)', '30 Days Credit', 'National Logistics'),
    ('ORD/DEMO/000003', 'Spare Parts Order', 'Chennai Dealer Hub', 'TO-PAY DOOR DELIVERY (FTL)', '60 Days Credit', 'Express Freight'),
    ('ORD/DEMO/000004', 'Service Parts Order', 'Hyderabad Dealer Hub', 'PAID DOOR DELIVERY WITHOUT CC', '45 Days Credit', 'Blue Dart Express'),
    ('ORD/DEMO/000005', 'Warranty Replacement', 'Delhi Dealer Hub', 'PAID - GODOWN DELIVERY', '90 Days Credit', 'Gati Logistics'),
    ('ORD/DEMO/000006', 'Export Order', 'Ahmedabad Dealer Hub', 'FREIGHT PAID - D/D AGST. C/C', 'Against Delivery', 'VRL Transport')
) AS v(order_no, order_category, dealer_address, delivery_term, payment_term, transporter)
WHERE NOT EXISTS (
    SELECT 1 FROM tbl_vayu_orders_header h WHERE h.order_no = v.order_no
);
