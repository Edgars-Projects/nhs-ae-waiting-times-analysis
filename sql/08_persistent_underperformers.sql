-- 08_persistent_underperformers.sql
-- Trusts that CONSISTENTLY miss the target: in the bottom fifth of
-- trusts nationally in at least four of the five years.
-- This answers the second half of the project question directly,
-- rather than relying on a single year's snapshot.

WITH banded AS (
    SELECT
        trust,
        region,
        year,
        pct_within_4hrs,
        NTILE(5) OVER (PARTITION BY year ORDER BY pct_within_4hrs) AS quintile
    FROM ae
)
SELECT
    trust,
    region,
    COUNT(*)                                   AS years_reported,
    SUM(CASE WHEN quintile = 1 THEN 1 ELSE 0 END) AS years_in_bottom_fifth,
    ROUND(AVG(pct_within_4hrs), 1)             AS avg_pct_within_4hrs,
    MIN(pct_within_4hrs)                       AS worst_year_pct
FROM banded
GROUP BY trust, region
HAVING SUM(CASE WHEN quintile = 1 THEN 1 ELSE 0 END) >= 4
ORDER BY years_in_bottom_fifth DESC, avg_pct_within_4hrs;
