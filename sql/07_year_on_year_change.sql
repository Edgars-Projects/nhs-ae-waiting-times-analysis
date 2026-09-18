-- 07_year_on_year_change.sql
-- How each region's (patient-weighted) performance moved year to year,
-- using the LAG window function.

WITH regional AS (
    SELECT
        region,
        year,
        SUM(total_within_4hrs) * 100.0 / SUM(total_attendances) AS pct
    FROM ae
    GROUP BY region, year
)
SELECT
    region,
    year,
    ROUND(pct, 1)                                               AS pct_within_4hrs,
    ROUND(pct - LAG(pct) OVER (PARTITION BY region ORDER BY year), 1)
                                                                AS change_vs_prior_year,
    ROUND(pct - FIRST_VALUE(pct) OVER (PARTITION BY region ORDER BY year), 1)
                                                                AS change_since_2021
FROM regional
ORDER BY region, year;
