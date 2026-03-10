-- Exercise 3-1

SELECT actor_id, first_name, last_name
FROM actors
ORDER BY last_name, first_name;

-- Exercise 3-2

SELECT actor_id, first_name, last_name
FROM actors
WHERE last_name = 'WILLIAMS' OR last_name = 'DAVIS';

-- Exercise 3-3

SELECT DISTINCT customer_id
FROM rental
WHERE date(rental_date) = '2005-07-05';

-- Exercise 3-4

SELECT c.email, r.return_date
FROM customer c
  INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY r.return_date;
