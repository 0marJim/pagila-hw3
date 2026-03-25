/*
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */
WITH recent_rentals AS (
    SELECT c.customer_id, c.first_name, c.last_name, cat.name as category_name
    FROM customer c
    JOIN LATERAL (
        SELECT inventory_id
        FROM rental r
        WHERE r.customer_id = c.customer_id
        ORDER BY rental_date DESC
        LIMIT 5
    ) r ON true
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
)
SELECT customer_id, first_name, last_name
FROM recent_rentals
WHERE category_name = 'Action'
GROUP BY customer_id, first_name, last_name
HAVING COUNT(*) >= 4
ORDER BY customer_id;
