-- View: v_customer_metrics
-- Purpose: Comines all customer-level metrics into a single analytical table.
-- Grain: 1 row per customer

CREATE OR REPLACE VIEW `seventh-jet-478719-g8.OnlineOrderII.v_customer_metrics` AS
SELECT
  v.customer_id,
  v.total_units_ordered,
  v.total_revenue,
  v.total_orders_placed,
  v.avg_order_value,

  r.recency as recency_days,
  r.tenure as tenure_days,

  em.months_elapsed,
  em.orders_over_elapsed_months,

  mo.avg_orders_per_active_month,

  ROUND(av.avg_days_between_orders,2) as avg_days_between_orders

FROM
  `seventh-jet-478719-g8.OnlineOrderII.v_customer_value` v
  LEFT JOIN `seventh-jet-478719-g8.OnlineOrderII.v_customer_recency_and_tenure` r USING (customer_id)
  LEFT JOIN `seventh-jet-478719-g8.OnlineOrderII.v_customer_orders_months_elapsed` em USING (customer_id)
  LEFT JOIN `seventh-jet-478719-g8.OnlineOrderII.v_customer_active_monthly_orders` mo USING (customer_id)
  LEFT JOIN `seventh-jet-478719-g8.OnlineOrderII.v_customer_avg_days_between` av USING (customer_id)