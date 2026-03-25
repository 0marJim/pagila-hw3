/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */
WITH film_revenue AS (
    SELECT
        i.film_id,
        SUM(p.amount) AS revenue
    FROM payment p
    JOIN rental r USING (rental_id)
    JOIN inventory i USING (inventory_id)
    GROUP BY i.film_id
)

SELECT *
FROM (
    SELECT
        a.actor_id,
        a.first_name,
        a.last_name,
        f.film_id,
        f.title,
        RANK() OVER (
            PARTITION BY a.actor_id
            ORDER BY fr.revenue DESC
        ) AS rank,
        fr.revenue
    FROM actor a
    JOIN film_actor fa USING (actor_id)
    JOIN film f USING (film_id)
    JOIN film_revenue fr USING (film_id)
) ranked
WHERE rank <= 3
ORDER BY actor_id, rank;
