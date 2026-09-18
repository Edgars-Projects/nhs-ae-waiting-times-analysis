-- 01_schema.sql
-- Table for the trust-level A&E data produced by the Python cleaning step
-- (one row per trust per March snapshot, 2021-2025).

DROP TABLE IF EXISTS ae_raw;

CREATE TABLE ae_raw (
    region             TEXT    NOT NULL,
    trust              TEXT    NOT NULL,
    att1               INTEGER NOT NULL,  -- Type 1 (major A&E) attendances
    att2               INTEGER NOT NULL,  -- Type 2 (single-specialty) attendances
    att_o              INTEGER NOT NULL,  -- Other A&E department attendances
    o4_1               INTEGER NOT NULL,  -- Type 1 attendances over 4 hours
    o4_2               INTEGER NOT NULL,  -- Type 2 attendances over 4 hours
    o4_o               INTEGER NOT NULL,  -- Other department attendances over 4 hours
    total_attendances  INTEGER NOT NULL,
    total_over_4hrs    INTEGER NOT NULL,
    pct_within_4hrs    REAL    NOT NULL,
    month              TEXT    NOT NULL   -- e.g. 'March 2025'
);
