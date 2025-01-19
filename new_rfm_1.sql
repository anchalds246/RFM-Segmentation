-- Step 1: Define the dataset start date
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

-- Step 3: Assign recency score
RFM_Recency_Score AS (
  SELECT
    user_crm_id,
    recency,
    CASE 
      WHEN recency <= 100  THEN '5'
      WHEN recency BETWEEN 101 AND 300 THEN '4'
      WHEN recency BETWEEN 301 AND 500 THEN '3'
      WHEN recency BETWEEN 501 AND 700 THEN '2'
      ELSE '1'
    END AS recency_score
  FROM
    recency_days
),

-- Step 4: Assign frequency score
RFM_Frequency_Score AS (
  SELECT
    user_crm_id,
    transaction_count,
    CASE
      WHEN transaction_count = 1 THEN '1'
      WHEN transaction_count BETWEEN 2 AND 5 THEN '2'
      WHEN transaction_count BETWEEN 6 AND 20 THEN '3'
      WHEN transaction_count BETWEEN 21 AND 100 THEN '4'
      Else '5'
    END AS frequency_score
  FROM
    `prism-insights.warehouse.users`
 
),

-- Step 5: Assign monetary value score
RFM_MV_Score AS (
  SELECT 
    user_crm_id, 
    total_revenue,
    CASE
      WHEN total_revenue <= 15 THEN '1'
      WHEN total_revenue BETWEEN 15.01 AND 50 THEN '2'
      WHEN total_revenue BETWEEN 50.01 AND 200 THEN '3'
      WHEN total_revenue BETWEEN 200.01 AND 1000 THEN '4'
      ELSE '5'
    END AS MV_score
  FROM
    `prism-insights.warehouse.users`
),

-- Step 6: Combine RFM scores and calculate overall RFM score
RFM_Segmentation AS (
  SELECT 
    r.user_crm_id,
    r.recency,
    r.recency_score,
    f.transaction_count,
    f.frequency_score,
    m.total_revenue,
    m.MV_score,
    CONCAT(r.recency_score, f.frequency_score, m.MV_score) AS rfm_score,
    CASE
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('555', '554', '544', '545', '454', '455', '445') THEN 'Champions'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('543', '444', '435', '355', '354', '345', '344', '335') THEN 'Loyal Customers'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('553', '551', '552', '541', '542', '533', '532', '451', '452', '441', '442', '431', '453', '433', '432', '423', '353', '352', '351', '342', '341', '333', '323') THEN 'Loyalty Builders'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('512', '511', '422', '421', '412', '411', '313') THEN 'Fresh Faces'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('525', '524', '523', '522', '521', '515', '514', '513', '425', '424', '413', '414', '415', '315', '314', '313') THEN 'Rising Stars'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('535', '534', '443', '434', '343', '334', '325', '324') THEN 'Need Attention'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('331', '321', '312', '221', '213', '231', '241', '251') THEN 'About To Sleep'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('255', '254', '245', '244', '243', '252', '242', '235', '234', '225', '224', '153', '152', '145', '143', '142', '135', '134', '133', '125', '124') THEN 'High-Risk Segment'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('155', '144', '214', '215', '115', '114', '113') THEN 'Cannot Lose Them'
      WHEN CONCAT(r.recency_score, f.frequency_score, m.MV_score) IN ('332', '322', '231', '241', '251', '233', '223', '222', '132', '123', '122', '212', '211') THEN 'Silent Shoppers'
      

      ELSE 'Lapsed'
    END AS segment
  FROM
    RFM_Recency_Score r
  JOIN
    RFM_Frequency_Score f
    ON r.user_crm_id = f.user_crm_id
  JOIN
    RFM_MV_Score m
    ON r.user_crm_id = m.user_crm_id
), Rfm_final_score as (

-- Final Output: View customer RFM segmentation
SELECT rfm.user_crm_id,
       rfm.recency,
       rfm.transaction_count,
       rfm.total_revenue,
       recency_score,
       frequency_score,
       MV_score,
       rfm_score,
       segment,
FROM RFM_Segmentation rfm 
)


SELECT rf.user_crm_id,
       
       rf.recency,
       rf.transaction_count,
       rf.total_revenue,
       recency_score,
       frequency_score,
       MV_score,
       rfm_score,
       segment,
FROM Rfm_final_score  rf