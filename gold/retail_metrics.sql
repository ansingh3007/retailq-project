-- retail_metrics.sql
-- Unity Catalog Metric View — a governed semantic layer over fact_sales, with
-- joins to product/calendar/customer dimensions. Dimensions carry natural-
-- language synonyms so Genie can resolve conversational queries against them.

CREATE VIEW retail_q.retail_semantic.retail_metrics
WITH METRICS
LANGUAGE YAML
AS $$
version: 1.1

source: retail_q.retail_gold.fact_sales
comment: Retail metrics for analyzing sales transactions, revenue, and product performance
joins:
  - name: product
    source: retail_q.retail_gold.dim_product
    on: source.product_id = product.product_id
  - name: calendar
    source: retail_q.retail_gold.dim_calendar
    on: source.transaction_date = calendar.date
  - name: customer
    source: retail_q.retail_gold.dim_customer
    on: source.customer_id = customer.customer_id

dimensions:
  - name: Transaction Date
    expr: calendar.date
    display_name: Transaction Date
    comment: Date when the transaction occurred
    format:
      type: date
      date_format: year_month_day
    synonyms:
      - date
      - sale date
      - transaction day
  - name: Year
    expr: calendar.year
    display_name: Year
    comment: Year of the transaction
  - name: Quarter
    expr: calendar.quarter
    display_name: Quarter
    comment: Quarter of the transaction
  - name: Month Name
    expr: calendar.month_name
    display_name: Month
    comment: Month name of the transaction
    synonyms:
      - month
  - name: Product Category
    expr: product.category
    display_name: Product Category
    comment: Main product category
    synonyms:
      - category
  - name: Product Brand
    expr: product.brand
    display_name: Brand
    comment: Product brand name
    synonyms:
      - brand
  - name: Payment Mode
    expr: source.payment_mode
    display_name: Payment Mode
    comment: Method of payment used for transaction
    synonyms:
      - payment method
      - payment type
  - name: Sales Channel
    expr: source.sales_channel
    display_name: Sales Channel
    comment: Channel through which sale was made
    synonyms:
      - channel
  - name: Stage Name
    expr: source.stage_name
    display_name: Opportunity Stage
    comment: Sales opportunity stage
  - name: Customer Type
    expr: customer.customer_type
    display_name: Customer Type
    comment: Type or category of customer
    synonyms:
      - customer segment
      - customer category
  - name: Customer Name
    expr: customer.customer_name
    display_name: Customer Name
    comment: Name of the customer
    synonyms:
      - customer
  - name: Billing City
    expr: customer.billing_city
    display_name: City
    comment: Customer billing city
    synonyms:
      - city
      - customer city
  - name: Billing State
    expr: customer.billing_state
    display_name: State
    comment: Customer billing state
    synonyms:
      - state
      - customer state
  - name: Billing Country
    expr: customer.billing_country
    display_name: Country
    comment: Customer billing country
    synonyms:
      - country
      - customer country
  - name: Industry
    expr: customer.industry
    display_name: Industry
    comment: Customer industry sector
    synonyms:
      - customer industry
      - sector

measures:
  - name: Transaction Count
    expr: COUNT(1)
    display_name: Transaction Count
    comment: Total number of transactions
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
    synonyms:
      - transactions
      - count
      - order count
  - name: Total Revenue
    expr: SUM(amount)
    display_name: Total Revenue
    comment: Sum of all transaction amounts
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
    synonyms:
      - revenue
      - sales
      - total sales
  - name: Total Quantity Sold
    expr: SUM(quantity)
    display_name: Total Quantity
    comment: Total number of items sold
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
    synonyms:
      - quantity
      - units sold
  - name: Total Discount
    expr: SUM(discount_amount)
    display_name: Total Discount
    comment: Sum of all discount amounts
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
    synonyms:
      - discounts
  - name: Average Transaction Value
    expr: SUM(amount) / COUNT(1)
    display_name: Avg Transaction Value
    comment: Average revenue per transaction
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
    synonyms:
      - avg revenue
      - average order value
  - name: Unique Customers
    expr: COUNT(DISTINCT customer.customer_id)
    display_name: Unique Customers
    comment: Count of distinct customers
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
    synonyms:
      - customer count
      - distinct customers
$$
