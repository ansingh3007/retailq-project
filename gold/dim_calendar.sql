-- dim_calendar.sql
-- Calendar/date dimension table used by the Unity Catalog Metric View for
-- Year / Quarter / Month Name breakdowns.

CREATE OR REPLACE TABLE retail_q.retail_gold.dim_calendar AS
WITH date_range AS (
  SELECT explode(sequence(
    to_date(:start_date),
    to_date(:end_date),
    interval 1 day
  )) AS date
)
SELECT
  date,
  year(date) AS year,
  quarter(date) AS quarter,
  month(date) AS month,
  date_format(date, 'MMMM') AS month_name,
  date_format(date, 'MMM') AS month_short_name,
  weekofyear(date) AS week_of_year,
  dayofmonth(date) AS day_of_month,
  dayofweek(date) AS day_of_week,
  date_format(date, 'EEEE') AS day_of_week_name,
  date_format(date, 'EEE') AS day_of_week_short_name,
  dayofyear(date) AS day_of_year,
  CASE WHEN dayofweek(date) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend,
  CASE WHEN dayofweek(date) NOT IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekday,
  concat(year(date), '-Q', quarter(date)) AS year_quarter,
  date_format(date, 'yyyy-MM') AS year_month,
  last_day(date) AS last_day_of_month,
  date = last_day(date) AS is_last_day_of_month,
  date = date_trunc('month', date) AS is_first_day_of_month
FROM date_range
ORDER BY date
