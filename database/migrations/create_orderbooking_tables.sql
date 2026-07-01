-- Tables required by orderbooking.php and order booking flow (complaint_management).

CREATE TABLE IF NOT EXISTS tbl_vayu_dpst_master (
    dpst VARCHAR(20) NOT NULL PRIMARY KEY,
    status SMALLINT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS area (
    area_code VARCHAR(10) NOT NULL PRIMARY KEY,
    area_desc VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS dealercode_and_transportercode (
    id SERIAL PRIMARY KEY,
    trans_code VARCHAR(20) NOT NULL,
    dealer_code VARCHAR(50),
    cuno VARCHAR(50)
);

CREATE INDEX IF NOT EXISTS idx_dealercode_transporter_trans_code
    ON dealercode_and_transportercode (trans_code);

CREATE TABLE IF NOT EXISTS customer_master (
    cuno VARCHAR(50) NOT NULL,
    adr_code VARCHAR(20) NOT NULL,
    country VARCHAR(10) NOT NULL DEFAULT 'IND',
    cuname VARCHAR(255),
    PRIMARY KEY (cuno, adr_code)
);

CREATE TABLE IF NOT EXISTS customer_address (
    cuno VARCHAR(50) NOT NULL,
    adr_code VARCHAR(20) NOT NULL,
    cuname VARCHAR(255) NOT NULL,
    custaddr TEXT,
    PRIMARY KEY (cuno, adr_code)
);

CREATE TABLE IF NOT EXISTS dpst_master (
    dpst_code VARCHAR(20) NOT NULL PRIMARY KEY,
    dpst_desc VARCHAR(255),
    product_group VARCHAR(50) NOT NULL DEFAULT 'SPARES'
);

CREATE TABLE IF NOT EXISTS elgi_item_master (
    item_code VARCHAR(50) NOT NULL PRIMARY KEY,
    hsn VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS gst_hsn (
    id SERIAL PRIMARY KEY,
    hsn VARCHAR(20) NOT NULL,
    company VARCHAR(10) NOT NULL DEFAULT '401',
    sgst VARCHAR(20),
    igst VARCHAR(20),
    cgst VARCHAR(20),
    UNIQUE (hsn, company)
);

CREATE TABLE IF NOT EXISTS plexecom_customer_units15062026 (
    oid SERIAL PRIMARY KEY,
    cuno VARCHAR(50),
    areacode VARCHAR(10),
    indent_number VARCHAR(50),
    indent_date DATE,
    refno VARCHAR(50),
    dpst VARCHAR(20),
    tplcode VARCHAR(50),
    qty NUMERIC(14, 2),
    price NUMERIC(14, 2)
);

CREATE INDEX IF NOT EXISTS idx_plexecom_units150_area_date
    ON plexecom_customer_units15062026 (areacode, indent_date);

CREATE SEQUENCE IF NOT EXISTS dp_spares START WITH 1001 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS plexecom_unique_sequence START WITH 50001 INCREMENT BY 1;
