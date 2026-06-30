-- Minimal lookup data for order booking / Recent Orders joins.

INSERT INTO tbl_vayu_delivery_term (delivery_code, delivery_term) VALUES
    ('003', 'FREIGHT PAID - D/D AGST. C/C'),
    ('508', 'TO PAY-D/D AGA CONSIGNEE COPY'),
    ('509', 'TOPAY-DOOR DELIVERY CC ATTACHED'),
    ('581', 'TOPAY - GODOWN DELIVERY'),
    ('545', 'TO-PAY DOOR DELIVERY (FTL)'),
    ('540', 'TOPAY - DOOR DELIVERY ( LCV)'),
    ('011', 'PAID-DOOR DELY REIM CC ATTACH'),
    ('013', 'PAID-DD AGST CC REIM-PART LOAD'),
    ('579', 'TOPAY-DOOR DELY AGNST C/C(FTL)'),
    ('580', 'PAID-D/D AGNST C/C (FTL)'),
    ('546', 'PAID - GODOWN DELIVERY'),
    ('004', 'PAID - DOOR DELY CC ATTACHED'),
    ('010', 'PAID-DOOR DELIVERY REIM-FTL'),
    ('541', 'PAID - DOOR DELIVERY (FTL)'),
    ('122', 'PAID DOOR DELIVERY WITHOUT CC')
ON CONFLICT (delivery_code) DO NOTHING;

INSERT INTO tbl_vayu_order_category (id, order_category, status) VALUES
    (0, 'Uncategorized', 1),
    (1, 'Standard Order', 1),
    (2, 'Special Order', 1),
    (3, 'Export Order', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO spp_payterm_master (pay_code, pay_desc, dpst, valid) VALUES
    ('660', '100% Advance', '90092', 'Y'),
    ('001', '30 Days Credit', '90092', 'Y'),
    ('002', '60 Days Credit', '90092', 'Y')
ON CONFLICT (pay_code, dpst) DO NOTHING;

INSERT INTO transporter_master (trans_code, trans_name) VALUES
    ('T50', 'Sample Transporter'),
    ('T01', 'National Logistics'),
    ('T02', 'Express Freight')
ON CONFLICT (trans_code) DO NOTHING;
