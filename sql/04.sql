/*
 * List the first and last names of all actors who:
 * 1. have appeared in at least one movie in the "Children" category,
 * 2. but that have never appeared in any movie in the "Horror" category.
 */
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    -- Subquery 1: Find all actors in Children movies
    SELECT film_actor.actor_id
    FROM film_actor
    JOIN film_category ON film_actor.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = 'Children'
)
AND actor_id NOT IN (
    -- Subquery 2: Find all actors in Horror movies
    SELECT film_actor.actor_id
    FROM film_actor
    JOIN film_category ON film_actor.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = 'Horror'
)
ORDER BY last_name, first_name;
