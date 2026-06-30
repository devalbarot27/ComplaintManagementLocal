-- dealerportal: commitment dates for pending orders (orderClass.php getPendingOrderList).

CREATE TABLE IF NOT EXISTS tbl_commitment (
    orderno VARCHAR(50) NOT NULL,
    posno SMALLINT NOT NULL,
    comm_dt DATE NULL,
    PRIMARY KEY (orderno, posno)
);

-- dealerportal: LR listing (orderClass.php getLrDetails).

CREATE TABLE IF NOT EXISTS lrdetails (
    cuno VARCHAR(50) NOT NULL,
    divcode VARCHAR(10) NOT NULL DEFAULT '1',
    ordno VARCHAR(50) NOT NULL,
    invno INTEGER NOT NULL,
    invdate DATE NULL,
    invref VARCHAR(50) NOT NULL,
    dpst VARCHAR(50) NULL,
    lrno VARCHAR(50) NULL,
    lrdate DATE NULL,
    tname VARCHAR(255) NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_lrdetails_cuno_ordno_inv
    ON lrdetails (cuno, ordno, invno, invref);

CREATE INDEX IF NOT EXISTS idx_lrdetails_cuno_divcode
    ON lrdetails (cuno, divcode);

CREATE INDEX IF NOT EXISTS idx_tbl_commitment_orderno_posno
    ON tbl_commitment (orderno, posno);
