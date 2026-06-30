-- Order booking cart + order line tables (complaint_management).

CREATE TABLE IF NOT EXISTS tbl_vayu_cartitems (
    id SERIAL PRIMARY KEY,
    item_code VARCHAR(50) NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    price NUMERIC(14, 2) NOT NULL DEFAULT 0,
    qty NUMERIC(14, 2) NOT NULL DEFAULT 1,
    total_amount NUMERIC(14, 2) NOT NULL DEFAULT 0,
    created_by VARCHAR(50) NOT NULL,
    status INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tbl_vayu_cartitems_created_by_status
    ON tbl_vayu_cartitems (created_by, status);

CREATE TABLE IF NOT EXISTS tbl_vayu_orders_line (
    id SERIAL PRIMARY KEY,
    order_no VARCHAR(50) NOT NULL,
    item_code VARCHAR(50) NOT NULL,
    item_description VARCHAR(255) NOT NULL,
    quantity NUMERIC(14, 2) NOT NULL DEFAULT 1,
    price NUMERIC(14, 2) NOT NULL DEFAULT 0,
    total_amount NUMERIC(14, 2) NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_tbl_vayu_orders_line_order_no
    ON tbl_vayu_orders_line (order_no);
