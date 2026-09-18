-- 03_clean_view.sql
-- A clean, analysis-ready view. Every later query reads from this,
-- so the cleaning rules live in exactly one place.

DROP VIEW IF EXISTS ae;

CREATE VIEW ae AS
SELECT
    TRIM(region)                                   AS region,
    trust,
    CAST(SUBSTR(month, -4) AS INTEGER)             AS year,
    att1                                           AS type1_attendances,
    o4_1                                           AS type1_over_4hrs,
    total_attendances,
    total_over_4hrs,
    total_attendances - total_over_4hrs            AS total_within_4hrs,
    ROUND((total_attendances - total_over_4hrs) * 100.0
          / total_attendances, 1)                  AS pct_within_4hrs,
    ROUND((att1 - o4_1) * 100.0 / att1, 1)         AS type1_pct_within_4hrs
FROM ae_raw
WHERE TRIM(region) <> 'Total'     -- drop national summary rows
  AND att1 >= 100;                -- major A&E providers only
