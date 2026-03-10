-- syntax
WITH MyTempTable AS (
  SELECT col1, col2, col3
  FROM real_table
  WHERE condition = true
) 
SELECT * FROM MyTempTable;

--------------------------------------------

WITH user_spend AS (
  SELECT user_id, SUM(amount) as total_spend
  FROM orders
  GROUP BY user_id
),
store_avg AS (
  SELECT AVG(amount) as avg_amount 
  FROM orders
)
SELECT u.user_id, u.total_spend
FROM user_spend u, store_avg s
WHERE u.total_spend > s.avg_amount;

-- multi step aggregation
WITH DeptTotals AS (
  SELECT 
    department_id, 
    SUM(sale_amount) as total_sales
  FROM sales
  GROUP BY department_id
)
SELECT 
  AVG(total_sales) as avg_departmental_revenue
FROM DeptTotals;

-- chaining
WITH RawData AS (
  SELECT * FROM web_logs WHERE status_code = 200
),
FormattedData AS (
  SELECT
    user_id,
    UPPER(page_path) as page,
    view_time::DATE as view_date
  FROM RawData
),
DailyCounts AS (
  SELECT
    view_date,
    COUNT(DISTINCT user_id) as unique_users
  FROM FormattedData
  GROUP BY view_date
)
SELECT * FROM DailyCounts ORDER BY view_date DESC;