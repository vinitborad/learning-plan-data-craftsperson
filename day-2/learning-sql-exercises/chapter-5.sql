-- Exercie 5-1

SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer c
  INNER JOIN address a ON c.address_id = a.address_id
  INNER JOIN city ct ON a.city_id = ct.city_id
WHERE a.district = 'California';

-- Exercise 5-2

SELECT f.title
FROM film f
  INNER JOIN film_actor fa ON f.film_id = fa.film_id
  INNER JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.first_name = 'JOHN';
