

/* --------------------------------------------------------
   1. Count of purchases per month (excluding refunded ones)
---------------------------------------------------------*/
SELECT 
    DATE_TRUNC('month', purchase_time) AS purchase_month,
    COUNT(*) AS total_purchases
FROM transactions
WHERE refund_time IS NULL
GROUP BY 1
ORDER BY 1;



/* --------------------------------------------------------
   2. Stores with at least 5 transactions in Oct 2020
      Only valid (non-refunded) purchases considered
---------------------------------------------------------*/
WITH october_data AS (
    SELECT store_id
    FROM transactions
    WHERE refund_time IS NULL
      AND purchase_time >= '2020-10-01'
      AND purchase_time <  '2020-11-01'
)
SELECT 
    store_id,
    COUNT(*) AS order_count
FROM october_data
GROUP BY store_id
HAVING COUNT(*) >= 5;



/* --------------------------------------------------------
   3. Shortest interval (in minutes) from purchase to refund
---------------------------------------------------------*/
SELECT 
    store_id,
    MIN(EXTRACT(EPOCH FROM (refund_time - purchase_time)) / 60)
        AS shortest_refund_interval_min
FROM transactions
WHERE refund_time IS NOT NULL
GROUP BY store_id;



/* --------------------------------------------------------
   4. Gross transaction value of each store’s FIRST order
---------------------------------------------------------*/
WITH ranked AS (
    SELECT 
        store_id,
        purchase_time,
        gross_transaction_value,
        ROW_NUMBER() OVER (
            PARTITION BY store_id
            ORDER BY purchase_time
        ) AS rn
    FROM transactions
)
SELECT 
    store_id,
    purchase_time AS first_order_time,
    gross_transaction_value
FROM ranked
WHERE rn = 1;



/* --------------------------------------------------------
   5. Most popular item name among first-time purchases
---------------------------------------------------------*/
WITH first_buy AS (
    SELECT 
        t.buyer_id,
        t.item_id,
        ROW_NUMBER() OVER (
            PARTITION BY t.buyer_id 
            ORDER BY t.purchase_time
        ) AS rn
    FROM transactions t
)
SELECT 
    i.item_name,
    COUNT(*) AS times_ordered
FROM first_buy fb
JOIN items i ON fb.item_id = i.item_id
WHERE fb.rn = 1
GROUP BY i.item_name
ORDER BY times_ordered DESC
LIMIT 1;



/* --------------------------------------------------------
   6. Flag if refund is allowed (refund <= 72 hours)
   72 hours = 4320 minutes
---------------------------------------------------------*/
SELECT 
    t.*,
    CASE 
        WHEN refund_time IS NOT NULL
         AND EXTRACT(EPOCH FROM (refund_time - purchase_time)) / 3600 <= 72
        THEN 1
        ELSE 0
    END AS refund_allowed
FROM transactions t;



/* --------------------------------------------------------
   7. Rank purchases per buyer & return only the 2nd purchase
      Refunds are ignored
---------------------------------------------------------*/
WITH filtered AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY buyer_id 
            ORDER BY purchase_time
        ) AS rn
    FROM transactions
    WHERE refund_time IS NULL
)
SELECT buyer_id, purchase_time, item_id, store_id
FROM filtered
WHERE rn = 2;



/* --------------------------------------------------------
   8. Find second transaction time per buyer 
      (Do NOT use MIN or MAX)
---------------------------------------------------------*/
WITH ranked AS (
    SELECT 
        buyer_id,
        purchase_time,
        ROW_NUMBER() OVER (
            PARTITION BY buyer_id 
            ORDER BY purchase_time
        ) AS rn
    FROM transactions
)
SELECT 
    buyer_id, 
    purchase_time AS second_transaction_time
FROM ranked
WHERE rn = 2;

