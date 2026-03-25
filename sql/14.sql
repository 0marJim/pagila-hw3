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
    -- Calculate total rentals per film
    SELECT
        f.film_id,
        f.title,
        COUNT(r.rental_id) AS total_rentals
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title
),
category_ranks AS (
    -- Rank films within each category using a deterministic tie-breaker
    SELECT
        c.name,
        fr.title,
        fr.total_rentals,
        RANK() OVER (
            PARTITION BY c.name
            ORDER BY fr.total_rentals DESC, fr.title ASC
        ) as rank
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film_rentals fr ON fc.film_id = fr.film_id
)
-- Select only the columns found in the expected output file
SELECT
    name,
    title,
    total_rentals AS "total rentals"
FROM category_ranks
WHERE rank <= 5
ORDER BY name, rank, title;
