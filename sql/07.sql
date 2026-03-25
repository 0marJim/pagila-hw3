/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */
-- Step 1: Define Bacall 0
WITH bacall_0 AS (
    SELECT actor_id
    FROM actor
    WHERE first_name = 'RUSSELL' AND last_name = 'BACALL'
),
-- Step 2: Define Bacall 1 (Shares a film with Bacall 0)
bacall_1 AS (
    SELECT DISTINCT fa1.actor_id
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE fa2.actor_id IN (SELECT actor_id FROM bacall_0)
),
-- Step 3: Define Bacall 2 (Shares a film with Bacall 1)
bacall_2 AS (
    SELECT DISTINCT fa3.actor_id
    FROM film_actor fa3
    JOIN film_actor fa4 ON fa3.film_id = fa4.film_id
    WHERE fa4.actor_id IN (SELECT actor_id FROM bacall_1)
)

-- Step 4: Output Bacall 2, explicitly filtering out 1 and 0
SELECT DISTINCT a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor a
WHERE a.actor_id IN (SELECT actor_id FROM bacall_2)
  AND a.actor_id NOT IN (SELECT actor_id FROM bacall_1)
  AND a.actor_id NOT IN (SELECT actor_id FROM bacall_0)
ORDER BY "Actor Name";
