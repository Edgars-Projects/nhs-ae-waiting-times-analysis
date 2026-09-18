-- 04_national_trend.sql
-- National four-hour performance by year, against the 95% standard.
-- Two averages are shown: the simple mean treats every trust equally
-- (as in the original Python analysis); the weighted figure counts
-- every patient equally, so large trusts carry more weight.

SELECT
    year,
    COUNT(*)                                            AS trusts,
    SUM(total_attendances)                              AS attendances,
    ROUND(AVG(pct_within_4hrs), 1)                      AS avg_pct_within_4hrs,
    ROUND(SUM(total_within_4hrs) * 100.0
          / SUM(total_attendances), 1)                  AS weighted_pct_within_4hrs,
    ROUND(95 - SUM(total_within_4hrs) * 100.0
               / SUM(total_attendances), 1)             AS gap_to_95pct_target
FROM ae
GROUP BY year
ORDER BY year;
