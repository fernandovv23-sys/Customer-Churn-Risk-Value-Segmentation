-- View: v_customer_orders_months_elapsed
-- Purpose: Measures consistency via orders per elapsed months.
-- Grain: 1 row per customer

CREATE OR REPLACE VIEW `seventh-jet-478719-g8.OnlineOrderII.v_customer_orders_months_elapsed` AS
Select customer_id,
  COUNT(DISTINCT invoice) as total_orders,
  (DATE_DIFF(MAX(DATE(invoicedate)), MIN(DATE(invoicedate)),MONTH)+1) as months_elapsed,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT invoice),(DATE_DIFF(MAX(DATE(invoicedate)), MIN(DATE(invoicedate)),MONTH)+1)),2) as orders_over_elapsed_months
FROM `seventh-jet-478719-g8.OnlineOrderII.order_info_cleaned`
GROUP BY customer_id
ORDER BY orders_over_elapsed_months DESC