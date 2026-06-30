-- Orders module (complaint_management.orders) — used by order_helpers.php / installed base order linking.

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    order_year INTEGER NOT NULL,
    sequence_number INTEGER NOT NULL,
    fab_number VARCHAR(100) NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    invoice_date DATE NOT NULL,
    dealer_name VARCHAR(255) NOT NULL,
    machine_model VARCHAR(255) NOT NULL,
    created_by INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITHOUT TIME ZONE NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_orders_order_id_unique
    ON orders (order_id)
    WHERE deleted_at IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_orders_year_sequence_unique
    ON orders (order_year, sequence_number)
    WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_orders_deleted_at
    ON orders (deleted_at);
