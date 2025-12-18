-- View: v_customer_avg_days_between
-- Purpose: Calculates average days between order for repeat customers.
-- Grain: 1 row per customer

CREATE OR REPLACE VIEW `seventh-jet-478719-g8.OnlineOrderII.v_customer_avg_days_between` AS
with orders AS(
  SELECT
    customer_Id,
    DATE(invoicedate) as order_date,
    invoice
  FROM
    `seventh-jet-478719-g8.OnlineOrderII.order_info_cleaned`
),
gaps as (
  SELECT
    customer_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as previous_order_date
  FROM orders
)
SELECT
  customer_id,
  AVG(DATE_DIFF(order_date, previous_order_date, DAY)) as avg_days_between_orders
FROM gaps
WHERE previous_order_date IS NOT NULL
GROUP BY customer_id