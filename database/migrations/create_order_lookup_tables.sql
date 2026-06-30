-- Order booking / Recent Orders lookup tables (referenced by orderClass.php getRecentOrders).

CREATE TABLE IF NOT EXISTS tbl_vayu_delivery_term (
    delivery_code VARCHAR(10) NOT NULL PRIMARY KEY,
    delivery_term VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tbl_vayu_order_category (
    id INTEGER NOT NULL PRIMARY KEY,
    order_category VARCHAR(255) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS spp_payterm_master (
    pay_code VARCHAR(20) NOT NULL,
    pay_desc VARCHAR(255) NOT NULL,
    dpst VARCHAR(20) NOT NULL DEFAULT '90092',
    valid CHAR(1) NOT NULL DEFAULT 'Y',
    PRIMARY KEY (pay_code, dpst)
);

CREATE TABLE IF NOT EXISTS transporter_master (
    trans_code VARCHAR(20) NOT NULL PRIMARY KEY,
    trans_name VARCHAR(255) NOT NULL
);
