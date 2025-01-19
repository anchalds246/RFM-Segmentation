WITH revenue_stats AS (
  SELECT
    MIN(total_revenue) AS min_revenue,
    MAX(total_revenue) AS max_revenue,
    AVG(total_revenue) AS avg_revenue
  FROM
    `warehouse.users`
),
revenue_percentiles AS (
  SELECT
    PERCENTILE_CONT(total_revenue, 0.25) OVER () AS p25_revenue,
    PERCENTILE_CONT(total_revenue, 0.50) OVER () AS median_revenue,
    PERCENTILE_CONT(total_revenue, 0.75) OVER () AS p75_revenue
  FROM
    `warehouse.users`
  LIMIT 1
)
SELECT
  (SELECT COUNT(*) FROM `warehouse.users`) AS total_customers,
  min_revenue,
  max_revenue,
  ROUND(avg_revenue, 2) AS avg_revenue,
  p25_revenue,
  median_revenue,
  p75_revenue
FROM
  revenue_stats AS stats,
  revenue_percentiles AS percentiles;