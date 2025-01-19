WITH transaction_stats AS (
  SELECT
    MIN(transaction_count) AS min_transactions,
    MAX(transaction_count) AS max_transactions,
    AVG(transaction_count) AS avg_transactions
  FROM
    `warehouse.users`
),
transaction_percentiles AS (
  SELECT
    PERCENTILE_CONT(transaction_count, 0.25) OVER () AS p25_transactions,
    PERCENTILE_CONT(transaction_count, 0.50) OVER () AS median_transactions,
    PERCENTILE_CONT(transaction_count, 0.75) OVER () AS p75_transactions
  FROM
    `warehouse.users`
  LIMIT 1
)
SELECT
  (SELECT COUNT(*) FROM `warehouse.users`) AS total_customers,
  min_transactions,
  max_transactions,
  ROUND(avg_transactions, 2) AS avg_transactions,
  p25_transactions,
  median_transactions,
  p75_transactions
FROM
  transaction_stats AS stats,
  transaction_percentiles AS percentiles;