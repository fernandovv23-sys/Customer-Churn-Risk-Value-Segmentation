# Customer Churn Risk Analysis

## Business Problem
Identify high-value customers at risk of churn and distinguish them from growth and inactive segments.

## Dataset
Online Retail II (UCI) - Transactional Retail Data

## Approach
1.) Cleaned transactional data:
	- Removed cancellation
	- Removed invalid prices
	- Removed NULL customers & invoices
	- Excluded rows containing stockcode "B" as it was used as balance adjustments, contained NULL or negative prices and quantities

2.) Modeled customer-level metrics in BigQuery:
	- Revenue & Order Value
	- Recency & Tenure
	- Purchase cadence

3.) Built a rule-based churn risk segmentation:
	- Healthy
	- At Risk
	- Growth Potential
	- Inactive / Low Priority

## Key Insights
- ~1-2% of customers are high-value but at risk currently
- ~7% of customers are responsible for majority of repeat revenue
- There is a large amount of growth potential but are low value

## Dashboard
https://public.tableau.com/app/profile/fernando.velez.varela/viz/CustomerChurnRiskValueSegmentation/Dashboard1#1

## Data Model (BigQuery)

Customer analytics were built using a layered view approach in BgQuery to keep logic modular and auditable.

Core Views:
- `v_customer_value`
	Calculates revenue, order counts, units, and average order value per customer.
- `v_customer_recency_and_tenure`
	Measures day since last purchase (recency) and customer lifespan (tenure).
- `v_customer_avg_days_between
	Calculates average days between order for repeat customers.
- `v_customer_orders_month_elapsed`
	Measures consistency via orders per elapsed months.
- `v_customer_active_monthly_orders`
	Calculates order per active month.
- `v_customer_metrics`
	Comines all customer-level metrics into a single analytical table.
- `v_categorize_customers`
	Applies value and churn-risk segmentation logic.




