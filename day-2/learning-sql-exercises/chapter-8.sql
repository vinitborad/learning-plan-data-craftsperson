-- Exercise 8-1

SELECT COUNT(*) FROM payment;

-- Exercise 8.2

SELECT 
  customer_id,
  COUNT(*) AS num_of_payments,
  SUM(amount) AS total_payment 
FROM payment
GROUP BY customer_id;

-- Exercise 8.3

SELECT 
  customer_id,
  COUNT(*) AS num_of_payments,
  SUM(amount) AS total_payment 
FROM payment
GROUP BY customer_id
HAVING num_of_payments > 40;