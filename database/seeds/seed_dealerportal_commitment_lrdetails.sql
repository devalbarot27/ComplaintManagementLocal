-- Seed commitment rows from existing pending orders.

INSERT INTO tbl_commitment (orderno, posno, comm_dt)
SELECT TRIM(p.ordno), p.posno, COALESCE(p.delydt, p.orddt)
FROM pendingordersnew p
WHERE p.company != 600
ON CONFLICT (orderno, posno) DO NOTHING;

-- Seed LR rows from despatch + lr_details where available.

INSERT INTO lrdetails (
    cuno,
    divcode,
    ordno,
    invno,
    invdate,
    invref,
    dpst,
    lrno,
    lrdate,
    tname
)
SELECT DISTINCT
    TRIM(d.cuno),
    COALESCE(NULLIF(TRIM(d.division::text), ''), '1'),
    TRIM(d.ordno),
    d.invno,
    d.invdate,
    TRIM(d.invref),
    TRIM(d.dpst),
    lr.lrno,
    lr.lrdate,
    lr.tname
FROM despatch d
LEFT JOIN lr_details lr
    ON d.invref = lr.invref
   AND d.invno = lr.invno
   AND d.cmp = lr.company
WHERE d.cmp != 600
ON CONFLICT (cuno, ordno, invno, invref) DO NOTHING;
