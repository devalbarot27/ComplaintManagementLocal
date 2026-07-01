-- dealerportal: seed customer_master and cust_delivery_address for order_data.php

INSERT INTO customer_master (cuno, cuname, st1, st2, city, state)
SELECT DISTINCT ON (TRIM(ca.cuno))
    TRIM(ca.cuno),
    TRIM(ca.cuname),
    TRIM(ca.st1),
    TRIM(ca.st2),
    TRIM(ca.city),
    TRIM(ca.state)
FROM customer_address ca
WHERE TRIM(ca.cuno) <> ''
ORDER BY TRIM(ca.cuno), TRIM(ca.adr_code)
ON CONFLICT (cuno) DO NOTHING;

INSERT INTO customer_master (cuno, cuname, st1, st2, city, state) VALUES
    (
        'CU1A03751',
        'DEMO INDUSTRIES PVT LTD',
        'Plot 12, MIDC Andheri East',
        'Mumbai',
        'Mumbai',
        'Maharashtra'
    )
ON CONFLICT (cuno) DO NOTHING;

INSERT INTO cust_delivery_address (
    cuno, delivery_code, address1, address2, address3, address4, address5, address6
)
SELECT v.cuno, v.delivery_code, v.address1, v.address2, v.address3, v.address4, v.address5, v.address6
FROM (VALUES
    ('CU1A03751', '001', 'Demo Industries Pvt Ltd', 'Plot 12, MIDC Andheri East', 'Mumbai', 'Maharashtra', '400093', 'India'),
    ('CU1A03751', '002', 'Demo Industries - Pune Plant', 'Sector 7, Pimpri Industrial Area', 'Pune', 'Maharashtra', '411018', 'India'),
    ('CU1A03751', '003', 'Demo Industries - Chennai WH', '42 Ambattur Industrial Estate', 'Chennai', 'Tamil Nadu', '600058', 'India')
) AS v(cuno, delivery_code, address1, address2, address3, address4, address5, address6)
WHERE NOT EXISTS (
    SELECT 1
    FROM cust_delivery_address cda
    WHERE TRIM(cda.cuno) = v.cuno
      AND TRIM(cda.delivery_code) = v.delivery_code
);
