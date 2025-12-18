-- View: v_categorize_customers
-- Purpose: Applies value and churn-risk segmentation logic.
-- Grain: 1 row per customer

CREATE OR REPLACE VIEW `seventh-jet-478719-g8.OnlineOrderII.v_categorize_customers` AS
WITH base as(
  SELECT SUM(total_revenue) as total_overall_revenue
  FROM `seventh-jet-478719-g8.OnlineOrderII.v_customer_metrics`
),
calcs as(
    SELECT
     SAFE_DIVIDE(v.total_revenue, b.total_overall_revenue) as percentage_of_total_rev,
     v.customer_id,
     v.recency_days,
     v.avg_days_between_orders,
     v.tenure_days,
     v.total_orders_placed
    FROM
    `seventh-jet-478719-g8.OnlineOrderII.v_customer_metrics` v
    Cross JOIN base b
)
SELECT
  customer_id,
  CASE
    WHEN percentage_of_total_rev >= 0.002 THEN "High Value"
    WHEN percentage_of_total_rev > 0.0005 THEN "Mid Value"
    ELSE "Low Value"
  END AS value_segment,
  CASE
    WHEN (percentage_of_total_rev >= 0.002) and recency_days <= 30 THEN "High Revenue & Recent"
    WHEN (percentage_of_total_rev >= 0.002) and recency_days > 30 THEN "High Revenue & Stale"
    WHEN (percentage_of_total_rev > 0.0005) and recency_days <= 30 THEN "Mid Revenue & Recent"
    WHEN (percentage_of_total_rev > 0.0005) and recency_days > 30 THEN "Mid Revenue & Stale"
    WHEN (percentage_of_total_rev <= 0.0005) and recency_days <= 30 THEN "Low Revenue & Recent"
    ELSE "Low Revenue & Stale" 
  END as value_x_recency,
  CASE
    WHEN percentage_of_total_rev > 0.0005
      AND recency_days <= 30 
        THEN "Healthy"
    WHEN percentage_of_total_rev > 0.0005
      AND recency_days > 30
        THEN "At Risk"
    WHEN percentage_of_total_rev <= 0.0005
      AND recency_days <= 30
        THEN "Growth Potential"
    ELSE "Inactive / Low Priority"
    END AS churn_risk_segment,
  CASE
    WHEN total_orders_placed = 1 THEN "Single-order"
    WHEN avg_days_between_orders > 90 AND total_orders_placed > 1 THEN "Rare"
    WHEN avg_days_between_orders < 30 and total_orders_placed > 1 THEN "Frequent"
    ELSE "Occasional"
    END as cadence,
      CASE
    WHEN tenure_days > 180 THEN "Long-Term"
    WHEN tenure_days > 30 THEN "Established"
    ELSE "New"
  END as maturity
FROM calcs