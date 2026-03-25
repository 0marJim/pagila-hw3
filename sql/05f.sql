/*
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */
-- List 1: Movies that share at least 1 actor with AMERICAN CIRCUS (From Problem 5)
SELECT f2.title
FROM film f1
JOIN film_actor fa1 ON f1.film_id = fa1.film_id
JOIN film_actor fa2 ON fa1.actor_id = fa2.actor_id
JOIN film f2 ON fa2.film_id = f2.film_id
WHERE f1.title = 'AMERICAN CIRCUS'

INTERSECT

-- List 2: Movies that share 2 categories with AMERICAN CIRCUS (From Problem 5e)
SELECT f2.title
FROM film f1
JOIN film_category fc1 ON f1.film_id = fc1.film_id
JOIN film_category fc2 ON fc1.category_id = fc2.category_id
JOIN film f2 ON fc2.film_id = f2.film_id
WHERE f1.title = 'AMERICAN CIRCUS'
GROUP BY f2.title
HAVING COUNT(fc2.category_id) >= 2

-- Sort the final surviving list
ORDER BY title;
