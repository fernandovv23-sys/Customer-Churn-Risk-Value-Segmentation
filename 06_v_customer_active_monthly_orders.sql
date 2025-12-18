-- View: v_customer_orders_months_elapsed
-- Purpose: Calculates order per active month.
-- Grain: 1 row per customer

CREATE OR REPLACE VIEW `seventh-jet-478719-g8.OnlineOrderII.v_customer_orders_months_elapsed` AS
SELECT customer_id,
  COUNT(DISTINCT invoice) as total_orders,
  COUNT(DISTINCT FORMAT_DATE('%Y-%m', DATE(invoicedate))) as active_months,
  COUNT(DISTINCT invoice)/COUNT(DISTINCT FORMAT_DATE('%Y-%m', DATE(invoicedate))) as avg_orders_per_active_month
FROM
  seventh-jet-478719-g8.OnlineOrderII.order_info_cleaned
GROUP BY customer_ID
ORDER BY total_orders DESC