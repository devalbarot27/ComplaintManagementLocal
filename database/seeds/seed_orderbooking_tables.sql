-- Seed data for orderbooking.php dropdowns and order submit flow (demo customer CU1A03751).

INSERT INTO tbl_vayu_dpst_master (dpst, status) VALUES
    ('90092', 1),
    ('90079', 1),
    ('90001', 1),
    ('90042', 1),
    ('90040', 1),
    ('90999', 1)
ON CONFLICT (dpst) DO NOTHING;

INSERT INTO area (area_code, area_desc) VALUES
    ('011', 'Delhi'),
    ('021', 'Mumbai'),
    ('031', 'Pune'),
    ('041', 'Chennai'),
    ('051', 'Hyderabad'),
    ('058', 'Kolkata')
ON CONFLICT (area_code) DO NOTHING;

INSERT INTO dpst_master (dpst_code, dpst_desc, product_group) VALUES
    ('90092', 'Spares Depot Mumbai', 'SPARES'),
    ('90079', 'Spares Depot South', 'SPARES'),
    ('90001', 'Compressor Depot North', 'SPARES'),
    ('90042', 'Washing Depot West', 'WASHING'),
    ('90040', 'Industrial Depot East', 'SPARES'),
    ('90999', 'Central Depot', 'SPARES')
ON CONFLICT (dpst_code) DO NOTHING;

INSERT INTO dealercode_and_transportercode (trans_code, dealer_code, cuno)
SELECT v.trans_code, v.dealer_code, v.cuno
FROM (VALUES
    ('T50', 'CU1A03751', 'CU1A03751'),
    ('T01', 'CU1A03751', 'CU1A03751'),
    ('T02', 'CU1A03751', 'CU1A03751'),
    ('T03', 'CU1A03751', 'CU1A03751'),
    ('T04', 'CU1A03751', 'CU1A03751'),
    ('T05', 'CU1A03751', 'CU1A03751')
) AS v(trans_code, dealer_code, cuno)
WHERE NOT EXISTS (
    SELECT 1 FROM dealercode_and_transportercode d
    WHERE d.trans_code = v.trans_code AND d.cuno = v.cuno
);

INSERT INTO customer_master (cuno, adr_code, country, cuname) VALUES
    ('CU1A03751', 'ADDEM0001', 'IND', 'Demo Industries - Mumbai Hub'),
    ('CU1A03751', 'ADDEM0002', 'IND', 'Demo Industries - Pune Plant'),
    ('CU1A03751', 'ADDEM0003', 'IND', 'Demo Industries - Chennai WH'),
    ('CU1A03751', 'ADDEM0004', 'IND', 'Demo Industries - Hyderabad Site'),
    ('CU1A03751', 'ADDEM0005', 'IND', 'Demo Industries - Delhi Office'),
    ('CU1A03751', 'ADDEM0006', 'IND', 'Demo Industries - Kolkata Depot')
ON CONFLICT (cuno, adr_code) DO NOTHING;

INSERT INTO customer_address (cuno, adr_code, cuname, custaddr) VALUES
    ('CU1A03751', 'ADDEM0001', 'Demo Industries - Mumbai Hub', 'Plot 12, MIDC Andheri East, Mumbai, Maharashtra 400093'),
    ('CU1A03751', 'ADDEM0002', 'Demo Industries - Pune Plant', 'Sector 7, Pimpri Industrial Area, Pune, Maharashtra 411018'),
    ('CU1A03751', 'ADDEM0003', 'Demo Industries - Chennai WH', '42 Ambattur Industrial Estate, Chennai, Tamil Nadu 600058'),
    ('CU1A03751', 'ADDEM0004', 'Demo Industries - Hyderabad Site', '8 HITEC City Road, Hyderabad, Telangana 500081'),
    ('CU1A03751', 'ADDEM0005', 'Demo Industries - Delhi Office', '22 Okhla Industrial Area, New Delhi 110020'),
    ('CU1A03751', 'ADDEM0006', 'Demo Industries - Kolkata Depot', '15 Taratala Road, Kolkata, West Bengal 700088')
ON CONFLICT (cuno, adr_code) DO NOTHING;

INSERT INTO elgi_item_master (item_code, hsn) VALUES
    ('SP-10001', '8421'),
    ('SP-10002', '8414'),
    ('SP-10003', '8483'),
    ('SP-10004', '9032'),
    ('SP-10005', '8481'),
    ('SP-10006', '4009')
ON CONFLICT (item_code) DO NOTHING;

INSERT INTO gst_hsn (hsn, company, sgst, igst, cgst) VALUES
    ('8421', '401', 'GSTAG05', 'GSTAG18', 'GSTAG09'),
    ('8414', '401', 'GSTAG05', 'GSTAG18', 'GSTAG09'),
    ('8483', '401', 'GSTAG05', 'GSTAG18', 'GSTAG09'),
    ('9032', '401', 'GSTAG05', 'GSTAG18', 'GSTAG09'),
    ('8481', '401', 'GSTAG05', 'GSTAG18', 'GSTAG09'),
    ('4009', '401', 'GSTAG05', 'GSTAG18', 'GSTAG09')
ON CONFLICT (hsn, company) DO NOTHING;

-- Product pricing for cart items (submitCart uses dpst 90092).
INSERT INTO product_master (
    dpst, product_group, tplcode, tpldesc, dealer_price, tod_flag,
    excisable, mc, vc, fc, cos, valid, warehouse, otcode, status
)
SELECT
    90092, 'SPARES', v.tplcode, v.tpldesc, '0', 'N',
    '1', 0, 0, 0, v.cos, 'Y', '353', '611', 'YES'
FROM (VALUES
    ('SP-10001', 'Air Filter Element AF-200', 1250.00),
    ('SP-10002', 'Oil Separator OS-350', 4800.00),
    ('SP-10003', 'Belt Set BS-110', 890.00),
    ('SP-10004', 'Pressure Switch PS-45', 2100.00),
    ('SP-10005', 'Drain Valve DV-22', 650.00),
    ('SP-10006', 'Coolant Hose CH-88', 420.00)
) AS v(tplcode, tpldesc, cos)
WHERE NOT EXISTS (
    SELECT 1 FROM product_master p WHERE p.tplcode = v.tplcode AND p.dpst = 90092
);

INSERT INTO plexecom_customer_units15062026 (cuno, areacode, indent_number, indent_date, refno, dpst, tplcode, qty, price)
SELECT 'CU1A03751', v.areacode, v.indent_number, v.indent_date::date, v.refno, '90092', v.tplcode, v.qty, v.price
FROM (VALUES
    ('021', '1NA01', '2026-03-01', 'E/DEMO/250001', 'SP-10001', 2, 1250.00),
    ('031', '1NA02', '2026-03-05', 'E/DEMO/250002', 'SP-10002', 1, 4800.00),
    ('041', '2NA01', '2026-03-08', 'E/DEMO/250003', 'SP-10003', 3, 890.00),
    ('051', '2NA02', '2026-03-12', 'E/DEMO/250004', 'SP-10004', 1, 2100.00),
    ('011', '4NA01', '2026-03-15', 'E/DEMO/250005', 'SP-10005', 4, 650.00),
    ('058', '5NA01', '2026-03-18', 'E/DEMO/250006', 'SP-10006', 2, 420.00)
) AS v(areacode, indent_number, indent_date, refno, tplcode, qty, price)
WHERE NOT EXISTS (
    SELECT 1 FROM plexecom_customer_units15062026 p WHERE p.refno = v.refno
);
