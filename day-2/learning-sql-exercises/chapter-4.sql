-- Exercise 4-3

SELECT * FROM payments
WHERE amount IN (1.98, 7.98, 9.98);

-- Exercise 4-4

SELECT * FROM customer
WHERE last_name LIKE '_A%W%';
