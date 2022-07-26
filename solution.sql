USE SAKILA;
-- 1
SELECT COUNT(DISTINCT(last_name))
	FROM actor;
-- 2
SELECT COUNT(language_id)
	FROM film;
-- 3
SELECT COUNT(film_id)
	FROM film
    WHERE rating = "PG-13";
-- 4
SELECT title, length
	FROM film
    WHERE release_year = 2006
    ORDER BY length desc
    LIMIT 10;
-- 5
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) FROM rental;
-- 6
SELECT *, EXTRACT(MONTH FROM rental_date) as month, DAYOFWEEK(rental_date) as weekday
	FROM rental
    LIMIT 20;
-- 7
SELECT *, EXTRACT(MONTH FROM rental_date) as month, DAYOFWEEK(rental_date) as weekday, 
	(CASE
		WHEN DAYOFWEEK(rental_date) < 6 THEN 'weekday'
        ELSE 'weekend'
	END) as day_type
	FROM rental
    LIMIT 20;
-- 8
SELECT COUNT(rental_id)
	FROM rental
    WHERE (SELECT EXTRACT(MONTH FROM (rental_date))) = (SELECT EXTRACT(MONTH FROM (SELECT rental_date FROM rental
	ORDER BY rental_date desc
    LIMIT 1))) AND (SELECT EXTRACT(YEAR FROM (rental_date)))=(SELECT EXTRACT(YEAR FROM (SELECT rental_date FROM rental
	ORDER BY rental_date desc
    LIMIT 1)));
-- 9
SELECT DISTINCT(rating)
	FROM film;
-- 10
SELECT DISTINCT(release_year)
	FROM film;
-- 11
SELECT title
	FROM film
    WHERE title REGEXP 'armageddon';
-- 12
SELECT title
	FROM film
    WHERE title REGEXP 'apollo';
-- 13
SELECT title
	FROM film
    WHERE title REGEXP 'apollo$';
-- 14
SELECT title
	FROM film
    WHERE title REGEXP ' date | date$|^date |^date$';
-- 15
SELECT title
	FROM film
    ORDER BY LENGTH(title) desc
    LIMIT 10;
-- 16
SELECT title
	FROM film
    ORDER BY length desc
    LIMIT 10;
-- 17
SELECT count(film_id)
	FROM film
	WHERE special_features REGEXP "Behind";
-- 18
SELECT title, release_year
	FROM film
    ORDER BY release_year, title asc;
-- 19
ALTER TABLE staff
DROP COLUMN picture;
-- 20
INSERT INTO staff(staff_id, first_name, last_name, address_id, store_id, username)
VALUES (3, 'Tammy', 'Sanders', 4, 2, 'Tammy');
-- 21
INSERT INTO rental(rental_id, rental_date, inventory_id, customer_id, staff_id)
VALUES(
	16050,
    (SELECT current_timestamp()),
    (select inventory_id from inventory
    where film_id = (select film_id from film where title = 'Academy Dinosaur' LIMIT 1) LIMIT 1),
    (select customer_id from customer
	where first_name = 'CHARLOTTE' and last_name = 'HUNTER' LIMIT 1),
    (select staff_id from staff
	where store_id = 1 LIMIT 1)
    );
-- 22
CREATE TABLE backup_table
AS SELECT
  *
FROM customer
WHERE active = 0;

SET FOREIGN_KEY_CHECKS=0;
DELETE FROM customer
WHERE active = 0;
SET FOREIGN_KEY_CHECKS=1;