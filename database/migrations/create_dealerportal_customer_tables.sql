-- dealerportal: tables required by order_data.php

CREATE TABLE IF NOT EXISTS customer_master (
    cuno VARCHAR(50) NOT NULL PRIMARY KEY,
    cuname VARCHAR(255),
    st1 VARCHAR(255),
    st2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS cust_delivery_address (
    cuno VARCHAR(50) NOT NULL,
    delivery_code VARCHAR(10) NOT NULL,
    address1 VARCHAR(255),
    address2 VARCHAR(255),
    address3 VARCHAR(255),
    address4 VARCHAR(255),
    address5 VARCHAR(255),
    address6 VARCHAR(255),
    PRIMARY KEY (cuno, delivery_code)
);

CREATE INDEX IF NOT EXISTS idx_customer_master_cuname
    ON customer_master (cuname);

CREATE INDEX IF NOT EXISTS idx_cust_delivery_address_cuno
    ON cust_delivery_address (cuno);
