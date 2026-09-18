-- 05_regional_performance.sql
-- Regional four-hour performance by year, ranked within each year.

SELECT
    year,
    region,
    COUNT(*)                                            AS trusts,
    ROUND(AVG(pct_within_4hrs), 1)                      AS avg_pct_within_4hrs,
    ROUND(SUM(total_within_4hrs) * 100.0
          / SUM(total_attendances), 1)                  AS weighted_pct_within_4hrs,
    RANK() OVER (
        PARTITION BY year
        ORDER BY SUM(total_within_4hrs) * 1.0 / SUM(total_attendances)
    )                                                   AS rank_worst_first
FROM ae
GROUP BY year, region
ORDER BY year, rank_worst_first;
