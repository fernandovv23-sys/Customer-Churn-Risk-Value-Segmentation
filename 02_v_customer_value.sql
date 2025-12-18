-- View: v_customer_value
-- Purpose: Calculate revenue, order counts, units, and average order value per customer
-- Grain: 1 row per customer

CREATE OR REPLACE VIEW `seventh-jet-478719-g8.OnlineOrderII.v_customer_value` AS
WITH  insights as(
  Select customer_id,
    SUM(quantity) as total_units_ordered,
    ROUND(SUM(price * quantity),2) as total_revenue,
    COUNT(DISTINCT invoice) as total_orders_placed
  FROM
    seventh-jet-478719-g8.OnlineOrderII.order_info_cleaned
  Group BY customer_id
)

SELECT
  customer_id,
  total_units_ordered,
  total_revenue,
  total_orders_placed,
  ROUND(SAFE_DIVIDE(total_revenue, total_orders_placed),2) as avg_order_value
FROM insights
ORDER BY total_revenue DESC