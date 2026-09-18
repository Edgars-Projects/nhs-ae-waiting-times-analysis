-- 02_data_quality_checks.sql
-- Validate the data before analysing it. Each query should return the
-- number of problem rows; anything above zero needs attention.

-- 1. Rows per snapshot
SELECT month, COUNT(*) AS rows
FROM ae_raw
GROUP BY month
ORDER BY month;

-- 2. NHS summary ("Total") rows that slipped through the Python filter.
--    These are national totals, not trusts, and must be excluded.
SELECT month, trust, total_attendances, pct_within_4hrs
FROM ae_raw
WHERE TRIM(region) = 'Total' OR trust = 'TOTAL';

-- 3. Region names with stray leading/trailing spaces
--    (these would split one region into two in a GROUP BY).
SELECT DISTINCT '"' || region || '"' AS region_as_stored
FROM ae_raw
WHERE region <> TRIM(region);

-- 4. Totals that do not equal the sum of their parts
SELECT COUNT(*) AS bad_totals
FROM ae_raw
WHERE total_attendances <> att1 + att2 + att_o
   OR total_over_4hrs   <> o4_1 + o4_2 + o4_o;

-- 5. Percentage that does not match a recalculation from the raw counts
SELECT COUNT(*) AS bad_percentages
FROM ae_raw
WHERE ABS(pct_within_4hrs
          - ROUND((total_attendances - total_over_4hrs) * 100.0 / total_attendances, 1)) > 0.05;

-- 6. Duplicate trust-month rows
SELECT month, trust, COUNT(*) AS copies
FROM ae_raw
GROUP BY month, trust
HAVING COUNT(*) > 1;

-- 7. Impossible values
SELECT COUNT(*) AS impossible_rows
FROM ae_raw
WHERE total_over_4hrs > total_attendances
   OR total_attendances <= 0;
