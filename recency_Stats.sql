WITH earliest_date AS (
  SELECT MAX(latest_purchase_date) AS dataset_start_date
  FROM `prism-insights.warehouse.users`
),

-- Step 2: Calculate recency in days
recency_days AS ( 
  SELECT 
    user_crm_id,
    latest_purchase_date, 
    DATE_DIFF((SELECT dataset_start_date FROM earliest_date), latest_purchase_date, DAY) AS recency
  FROM 
    `prism-insights.warehouse.users`
),

recency_stats AS (
  SELECT
    MIN(recency) AS min_recency,
    MAX(recency) AS max_recency,
    AVG(recency) AS avg_recency
  FROM
    recency_days),

recency_percentiles AS (
  SELECT
    PERCENTILE_CONT(recency, 0.25) OVER () AS p25_recency,
    PERCENTILE_CONT(recency, 0.50) OVER () AS median_recency,
    PERCENTILE_CONT(recency, 0.75) OVER () AS p75_recency
  FROM
    `recency_days`
  LIMIT 1
)
SELECT
  (SELECT COUNT(*) FROM `warehouse.users`) AS total_customers,
  min_recency,
  max_recency,
  ROUND(avg_recency, 2) AS avg_recency,
  p25_recency,
  median_recency,
  p75_recency
FROM
  recency_stats AS stats,
  recency_percentiles AS percentiles;