-- Table: order_info_cleaned
-- Purpose: Clean transactional order data for customer-level analytics
--Key Filters:
	- Excludes cancellations and invalid transactions
	- Retains only revenue-generating order lines
-- Grain: 1 row per invoice line item

create or replace table seventh-jet-478719-g8.OnlineOrderII.order_info_cleaned AS
SELECT
  invoice as invoice,ss
  stockcode as stockcode,
  description as description,
  quantity as quantity,
  InvoiceDate as invoicedate,
  Price as price,
  `Customer ID` as customer_id,
  country as country
FROM seventh-jet-478719-g8.OnlineOrderII.order_info
WHERE 
  invoice not like 'C%' 
  AND stockcode <> "B"
  AND Quantity > 0
  AND Price > 0
  AND `Customer ID` IS NOT NULL
  AND InvoiceDate IS NOT NULL