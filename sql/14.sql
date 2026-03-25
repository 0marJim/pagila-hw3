/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */
WITH film_rentals AS (
    -- Calculate rental counts for ALL films
    SELECT
        f.film_id,
        f.title,
        COUNT(r.rental_id) AS total_rentals
    FROM film f
    LEFT JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title
)
SELECT
    name,
    title,
    "total rentals"
FROM (
    SELECT
        c.name,
        fr.title,
        fr.total_rentals AS "total rentals",
        -- Use title as a tie-breaker to ensure exactly 5 rows per category
        RANK() OVER (
            PARTITION BY c.name
            ORDER BY fr.total_rentals DESC, fr.title ASC
        ) as rank
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film_rentals fr ON fc.film_id = fr.film_id
) category_films
WHERE rank <= 5
ORDER BY name, rank, title;
