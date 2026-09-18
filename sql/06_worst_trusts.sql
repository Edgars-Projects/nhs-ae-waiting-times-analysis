-- 06_worst_trusts.sql
-- The five lowest-performing major A&E trusts in the latest year,
-- with their Type 1 (major A&E only) performance for comparison.

WITH ranked AS (
    SELECT
        year,
        trust,
        region,
        total_attendances,
        pct_within_4hrs,
        type1_pct_within_4hrs,
        RANK() OVER (PARTITION BY year ORDER BY pct_within_4hrs) AS rank_in_year
    FROM ae
)
SELECT rank_in_year, trust, region, total_attendances,
       pct_within_4hrs, type1_pct_within_4hrs
FROM ranked
WHERE year = (SELECT MAX(year) FROM ae)
  AND rank_in_year <= 5
ORDER BY rank_in_year;
