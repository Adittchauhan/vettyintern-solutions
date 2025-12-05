

/* --------------------------------------------------------
   1. Count of purchases per month (excluding refunded ones)
---------------------------------------------------------*/
SELECT
  DATE_FORMAT(purchase_time, '%Y-%m') AS purchase_month,
  COUNT(*) AS purchase_count
FROM transactions
WHERE refund_time IS NULL
GROUP BY DATE_FORMAT(purchase_time, '%Y-%m')
ORDER BY purchase_month;



/* --------------------------------------------------------
   2. Stores with at least 5 transactions in Oct 2020
      Only valid (non-refunded) purchases considered
---------------------------------------------------------*/
SELECT
  store_id,
  COUNT(*) AS oct_orders
FROM transactions
WHERE refund_time IS NULL
  AND purchase_time >= '2020-10-01' 
  AND purchase_time <  '2020-11-01'
GROUP BY store_id
HAVING COUNT(*) >= 5;



/* --------------------------------------------------------
   3. Shortest interval (in minutes) from purchase to refund
---------------------------------------------------------*/
SELECT
  store_id,
  MIN(TIMESTAMPDIFF(MINUTE, purchase_time, refund_time)) AS shortest_refund_minutes
FROM transactions
WHERE refund_time IS NOT NULL
GROUP BY store_id;




/* --------------------------------------------------------
   4. Gross transaction value of each store’s FIRST order
---------------------------------------------------------*/
SELECT
  t.store_id,
  t_first.first_purchase_time,
  t.gross_transaction_value
FROM (
  SELECT store_id, MIN(purchase_time) AS first_purchase_time
  FROM transactions
  GROUP BY store_id
) AS t_first
JOIN transactions t
  ON t.store_id = t_first.store_id
  AND t.purchase_time = t_first.first_purchase_time
ORDER BY t.store_id;



/* --------------------------------------------------------
   5. Most popular item name among first-time purchases
---------------------------------------------------------*/
WITH first_purchase_per_buyer AS (
  SELECT
    buyer_id,
    item_id,
    purchase_time,
    ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS rn
  FROM transactions
)
SELECT
  i.item_name,
  COUNT(*) AS first_purchase_count
FROM first_purchase_per_buyer f
JOIN items i ON f.item_id = i.item_id
WHERE f.rn = 1
GROUP BY i.item_name
ORDER BY first_purchase_count DESC
LIMIT 1;



/* --------------------------------------------------------
   6. Flag if refund is allowed (refund <= 72 hours)
   72 hours = 4320 minutes
---------------------------------------------------------*/
SELECT
  buyer_id,
  purchase_time,
  refund_time,
  store_id,
  item_id,
  gross_transaction_value,
  CASE
    WHEN refund_time IS NOT NULL
         AND TIMESTAMPDIFF(HOUR, purchase_time, refund_time) <= 72 THEN 1
    ELSE 0
  END AS refund_allowed
FROM transactions;


/* --------------------------------------------------------
   7. Rank purchases per buyer & return only the 2nd purchase
      Refunds are ignored
---------------------------------------------------------*/
WITH ranked_purchases AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS rn
  FROM transactions
  WHERE refund_time IS NULL
)
SELECT buyer_id, purchase_time, store_id, item_id, gross_transaction_value
FROM ranked_purchases
WHERE rn = 2;




/* --------------------------------------------------------
   8. Find second transaction time per buyer 
      (Do NOT use MIN or MAX)
---------------------------------------------------------*/
WITH ranked AS (
  SELECT
    buyer_id,
    purchase_time,
    ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS rn
  FROM transactions
)
SELECT buyer_id, purchase_time AS second_transaction_time
FROM ranked
WHERE rn = 2;

WHERE rn = 2;

