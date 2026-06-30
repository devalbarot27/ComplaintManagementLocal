-- Sample orders module records (6 rows).

INSERT INTO orders (
    order_id, order_year, sequence_number,
    fab_number, customer_name, invoice_date,
    dealer_name, machine_model, created_by
)
SELECT v.order_id, v.order_year, v.sequence_number, v.fab_number, v.customer_name,
       v.invoice_date::date, v.dealer_name, v.machine_model, v.created_by
FROM (VALUES
    ('ORD/2026/00001', 2026, 1, 'FAB-2026-001', 'Sharma Industries', '2026-01-10', 'Mumbai Dealer', 'EG-11', 1),
    ('ORD/2026/00002', 2026, 2, 'FAB-2026-002', 'Patel Manufacturing', '2026-02-05', 'Ahmedabad Dealer', 'EG-22', 1),
    ('ORD/2026/00003', 2026, 3, 'FAB-2026-003', 'Kumar Engineering', '2026-02-18', 'Chennai Dealer', 'EG-33', 1),
    ('ORD/2026/00004', 2026, 4, 'FAB-2026-004', 'Reddy Compressors', '2026-03-01', 'Hyderabad Dealer', 'EG-44', 1),
    ('ORD/2026/00005', 2026, 5, 'FAB-2026-005', 'Singh Auto Parts', '2026-03-12', 'Delhi Dealer', 'EG-55', 1),
    ('ORD/2026/00006', 2026, 6, 'FAB-2026-006', 'Mehta Fabricators', '2026-03-20', 'Pune Dealer', 'EG-66', 1)
) AS v(order_id, order_year, sequence_number, fab_number, customer_name, invoice_date, dealer_name, machine_model, created_by)
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.order_id = v.order_id
      AND o.deleted_at IS NULL
);
