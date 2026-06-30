-- dealerportal: sample data for order modules (6 rows per table).
-- Demo customer code matches orderClass.php filters: CU1A03751

-- Pending orders (6 rows)
INSERT INTO pendingordersnew (
    cuno, cuname, ordno, posno, orddt, indnodt, indentno, indentdate,
    itemcode, itemdesc, qty, unitvalue, delydt, div, area, dpst, dpst1,
    currency, pono, otcode, company
)
SELECT
    'CU1A03751', 'DEMO INDUSTRIES PVT LTD', v.ordno, v.posno,
    v.orddt::date, v.indnodt::date, v.indentno, v.indentdate::date,
    v.itemcode, v.itemdesc, v.qty, v.unitvalue, v.delydt::date,
    0, '021', '90079', '90079', 'IND', v.pono, '211', 401
FROM (VALUES
    ('204070102', 10, '2026-04-03', '2026-04-17', 'IND/26/P002', '1970-01-01', 'SP-10002', 'Oil Separator OS-350', 1, 4800.00, '2026-05-03', 'PO-PEND-002'),
    ('204070102', 10, '2026-04-03', '2026-04-17', 'IND/26/P002', '1970-01-01', 'SP-10002', 'Oil Separator OS-350', 1, 4800.00, '2026-05-03', 'PO-PEND-002'),
    ('204070103', 10, '2026-04-05', '2026-04-20', 'IND/26/P003', '1970-01-01', 'SP-10003', 'Belt Set BS-110', 3, 2670.00, '2026-05-05', 'PO-PEND-003'),
    ('204070104', 10, '2026-04-08', '2026-04-22', 'IND/26/P004', '1970-01-01', 'SP-10004', 'Pressure Switch PS-45', 1, 2100.00, '2026-05-08', 'PO-PEND-004'),
    ('204070105', 10, '2026-04-10', '2026-04-25', 'IND/26/P005', '1970-01-01', 'SP-10005', 'Drain Valve DV-22', 4, 2600.00, '2026-05-10', 'PO-PEND-005'),
    ('204070106', 10, '2026-04-12', '2026-04-28', 'IND/26/P006', '1970-01-01', 'SP-10006', 'Coolant Hose CH-88', 2, 840.00, '2026-05-12', 'PO-PEND-006')
) AS v(ordno, posno, orddt, indnodt, indentno, indentdate, itemcode, itemdesc, qty, unitvalue, delydt, pono)
WHERE NOT EXISTS (
    SELECT 1 FROM pendingordersnew p WHERE TRIM(p.ordno) = v.ordno AND p.posno = v.posno
);

-- Commitment dates for pending orders
INSERT INTO tbl_commitment (orderno, posno, comm_dt)
SELECT v.orderno, v.posno, v.comm_dt::date
FROM (VALUES
    ('204070101', 10, '2026-05-01'),
    ('204070102', 10, '2026-05-03'),
    ('204070103', 10, '2026-05-05'),
    ('204070104', 10, '2026-05-08'),
    ('204070105', 10, '2026-05-10'),
    ('204070106', 10, '2026-05-12')
) AS v(orderno, posno, comm_dt)
ON CONFLICT (orderno, posno) DO NOTHING;

-- Order acknowledgement (maintdealer) — 6 rows
INSERT INTO maintdealer (
    cuno, del_add, ordno, posno, seqno, ord_date, icode, item_desc, qty,
    uom, currency, price, earlierdate, latestdate, purno, dpst, payterms, delterms,
    div, area, cuname, areaname, company, otcode, blocked, totalrs
)
SELECT
    'CU1A03751', v.del_add, v.ordno, v.posno, 0, v.ord_date::date,
    v.icode, v.item_desc, v.qty, 'Nos', 'IND', v.price,
    v.ord_date::date, v.ord_date::date, v.purno, '90079', '660', '004',
    0, '021', 'DEMO INDUSTRIES PVT LTD', 'MUMBAI', 401, '211', 0, v.totalrs
FROM (VALUES
    ('ADDEM0001', '301001001', 10, '2026-02-01', 'SP-10001', 'Air Filter Element AF-200', 2, 1250.00, '4500039001', 2500.00),
    ('ADDEM0002', '301001002', 10, '2026-02-05', 'SP-10002', 'Oil Separator OS-350', 1, 4800.00, '4500039002', 4800.00),
    ('ADDEM0003', '301001003', 10, '2026-02-08', 'SP-10003', 'Belt Set BS-110', 3, 890.00, '4500039003', 2670.00),
    ('ADDEM0004', '301001004', 10, '2026-02-12', 'SP-10004', 'Pressure Switch PS-45', 1, 2100.00, '4500039004', 2100.00),
    ('ADDEM0005', '301001005', 10, '2026-02-15', 'SP-10005', 'Drain Valve DV-22', 4, 650.00, '4500039005', 2600.00),
    ('ADDEM0006', '301001006', 10, '2026-02-18', 'SP-10006', 'Coolant Hose CH-88', 2, 420.00, '4500039006', 840.00)
) AS v(del_add, ordno, posno, ord_date, icode, item_desc, qty, price, purno, totalrs)
WHERE NOT EXISTS (
    SELECT 1 FROM maintdealer m WHERE TRIM(m.ordno) = v.ordno AND m.posno = v.posno
);

-- Despatch details (6 rows)
INSERT INTO despatch (
    cuno, invref, invno, invdate, ordno, posno, ord_date, item_desc, qty, price,
    area, dpst, cuname, areaname, division, cmp, pono, despdate
)
SELECT
    'CU1A03751', v.invref, v.invno, v.invdate::date, v.ordno, 10,
    v.ord_date::date, v.item_desc, v.qty, v.price, '021', '90079',
    'DEMO INDUSTRIES PVT LTD', 'MUMBAI', 1, 401, v.pono, v.invdate::date
FROM (VALUES
    ('701', 34000101, '2026-01-10', '301001001', '2026-01-09', 'SP-10001 - Air Filter Element AF-200', 2, 1250.00, 'PO-DESP-001'),
    ('702', 34000102, '2026-01-15', '301001002', '2026-01-14', 'SP-10002 - Oil Separator OS-350', 1, 4800.00, 'PO-DESP-002'),
    ('703', 34000103, '2026-01-20', '301001003', '2026-01-19', 'SP-10003 - Belt Set BS-110', 3, 890.00, 'PO-DESP-003'),
    ('704', 34000104, '2026-01-25', '301001004', '2026-01-24', 'SP-10004 - Pressure Switch PS-45', 1, 2100.00, 'PO-DESP-004'),
    ('705', 34000105, '2026-02-01', '301001005', '2026-01-31', 'SP-10005 - Drain Valve DV-22', 4, 650.00, 'PO-DESP-005'),
    ('706', 34000106, '2026-02-05', '301001006', '2026-02-04', 'SP-10006 - Coolant Hose CH-88', 2, 420.00, 'PO-DESP-006')
) AS v(invref, invno, invdate, ordno, ord_date, item_desc, qty, price, pono)
WHERE NOT EXISTS (
    SELECT 1 FROM despatch d WHERE d.invref = v.invref AND d.invno = v.invno
);

-- LR details linked to despatch (6 rows)
INSERT INTO lr_details (
    invref, invno, invdt, ordno, cases, boxes, carton_box, bundles, spl_cases,
    ballets, weight, lrno, lrdate, dly_code, tcode, tname, company, lmdt
)
SELECT
    v.invref, v.invno, v.invdt::date, v.ordno, 0, 0, 0, 0, 0, 1,
    v.weight, v.lrno, v.lrdate::date, v.dly_code, v.tcode, v.tname, 401, CURRENT_TIMESTAMP
FROM (VALUES
    ('701', 34000101, '2026-01-10', '301001001', 45.5, 'LR-D-260001', '2026-01-11', '001000101', 'T50', 'Sample Transporter'),
    ('702', 34000102, '2026-01-15', '301001002', 120.0, 'LR-D-260002', '2026-01-16', '001000102', 'T01', 'National Logistics'),
    ('703', 34000103, '2026-01-20', '301001003', 32.0, 'LR-D-260003', '2026-01-21', '001000103', 'T02', 'Express Freight'),
    ('704', 34000104, '2026-01-25', '301001004', 18.5, 'LR-D-260004', '2026-01-26', '001000104', 'T03', 'Blue Dart Express'),
    ('705', 34000105, '2026-02-01', '301001005', 55.0, 'LR-D-260005', '2026-02-02', '001000105', 'T04', 'Gati Logistics'),
    ('706', 34000106, '2026-02-05', '301001006', 12.0, 'LR-D-260006', '2026-02-06', '001000106', 'T05', 'VRL Transport')
) AS v(invref, invno, invdt, ordno, weight, lrno, lrdate, dly_code, tcode, tname)
WHERE NOT EXISTS (
    SELECT 1 FROM lr_details l WHERE l.invref = v.invref AND l.invno = v.invno
);

-- LR details listing table (6 rows)
INSERT INTO lrdetails (
    cuno, divcode, ordno, invno, invdate, invref, dpst, lrno, lrdate, tname
)
SELECT
    'CU1A03751', '1', v.ordno, v.invno, v.invdate::date, v.invref,
    '90079', v.lrno, v.lrdate::date, v.tname
FROM (VALUES
    ('301001001', 34000101, '2026-01-10', '701', 'LR-D-260001', '2026-01-11', 'Sample Transporter'),
    ('301001002', 34000102, '2026-01-15', '702', 'LR-D-260002', '2026-01-16', 'National Logistics'),
    ('301001003', 34000103, '2026-01-20', '703', 'LR-D-260003', '2026-01-21', 'Express Freight'),
    ('301001004', 34000104, '2026-01-25', '704', 'LR-D-260004', '2026-01-26', 'Blue Dart Express'),
    ('301001005', 34000105, '2026-02-01', '705', 'LR-D-260005', '2026-02-02', 'Gati Logistics'),
    ('301001006', 34000106, '2026-02-05', '706', 'LR-D-260006', '2026-02-06', 'VRL Transport')
) AS v(ordno, invno, invdate, invref, lrno, lrdate, tname)
ON CONFLICT (cuno, ordno, invno, invref) DO NOTHING;
