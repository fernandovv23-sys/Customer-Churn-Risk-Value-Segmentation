-- View: v_customer_recency_and_tenure
-- Purpose: Calculate recency (days since last order and tenure (customer lifespan)
-- Grain: 1 row per customer

CREATE OR REPLACE VIEW `seventh-jet-478719-g8.OnlineOrderII.v_customer_recency_and_tenure` AS
WITH orders as (
  SELECT
    DISTINCT customer_id,
    invoice,
    DATE(invoicedate) as invoicedate,
  FROM seventh-jet-478719-g8.OnlineOrderII.order_info_cleaned
),
ref as(
  SELECT
    MAX(invoicedate) as reference_date
  FROM orders
),
cust as(
  SELECT
    customer_id,
    MAX(invoicedate) as last_order_date,
    MIN(invoicedate) as first_order_date,
    COUNT(DISTINCT invoice) as total_orders
  FROM
    orders
  GROUP BY customer_id
)
SELECT
  c.customer_id,
  r.reference_date,
  c.total_orders,
  c.first_order_date,
  c.last_order_date,
  DATE_DIFF(r.reference_date, c.last_order_date, DAY) as recency,
  DATE_DIFF(c.last_order_date, c.first_order_date, DAY) as tenure,
FROM cust c
CROSS JOIN ref r
ORDER BY recency 
