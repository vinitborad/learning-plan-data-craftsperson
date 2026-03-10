-- https://www.postgresql.org/docs/current/tutorial-window.html
SELECT
  depname,
  empno,
  salary,
  avg(salary) OVER (PARTITION BY depname)
FROM empsalary;

SELECT
  depname,
  empno,
  salary,
  row_number() OVER (PARTITION BY depname ORDER BY salary DESC)
FROM empsalary;

SELECT salary, sum(salary) OVER (ORDER BY salary) FROM empsalary;

SELECT 
  depname, empno, salary, enroll_date
FROM 
  (
    SELECT 
      depname, empno, salary, enroll_date,
      row_number() OVER (PARTITION BY depname ORDER BY salary DESC, empno) AS pos
    FROM empsalary
  ) AS ss
WHERE pos < 3;

-- Window functions (ROW_NUMBER RANK DENSE_RANK)

-- LAG and LEAD functions for time-series analysis
-- calcualting month on month revenue jump in terms of percentage
SELECT 
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
  (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100 AS growth_pct
FROM monthly_sales;

-- check when status of sensor changes, assume an iOT device
SELECT 
  timestamp,
  machine_status,
  LAG(machine_status) OVER (ORDER BY timestamp) AS last_status,
  CASE 
    WHEN machine_status != LAG(machine_status) OVER (ORDER BY timestamp) THEN 'Status Changed'
    ELSE 'Stable'
  END AS event_type
FROM factory_logs;

-- calculate how much time user spent on one page of website
SELECT 
  used_id,
  page_url,
  view_time AS start_time,
  LEAD(view_time) OVER (PARTITION BY used_id ORDER BY view_time) AS next_view_time,
  LEAD(view_time) OVER (PARTITION BY used_id ORDER BY view_time) - view_time AS duration
FROM page_views;