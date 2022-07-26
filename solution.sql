USE SAKILA;

#How many distinct (different) actors' last names are there?
SELECT COUNT(DISTINCT(last_name))
FROM actor;
    
#In how many different languages where the films originally produced? (Use the column language_id from the film table)
SELECT COUNT(language_id)
FROM film;

#How many movies were released with "PG-13" rating?
SELECT count(film_id)
from film
WHERE rating = "PG-13";

#Get 10 the longest movies from 2006.

SELECT title, length
FROM film
order by length DESC
limit 10;

#How many days has been the company operating (check DATEDIFF() function)?
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) FROM rental;


#Show rental info with additional columns month and weekday. Get 20.

SELECT *,
EXTRACT(MONTH FROM rental_date) AS month,
EXTRACT(DAY FROM rental_date) AS DAY
FROM rental;


#Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *, 
EXTRACT(MONTH FROM rental_date) as month, 
DAYOFWEEK(rental_date) as weekday, 
    (CASE
        WHEN DAYOFWEEK(rental_date) < 5 THEN "weekday"
        ELSE "weekend"
    END) as day_type
    FROM rental
    LIMIT 10;
    
#How many rentals were in the last month of activity?

select count(rental_id)
from rental
where rental_date <= '2006-02-14 15:16:03' and rental_date > "2006-01-14 15:16:03" ;

#Get release years.
select distinct release_year
from film;

#Get all films with ARMAGEDDON in the title.alter

select title
from film
WHERE title REGEXP 'armageddon';

#Get all films with APOLLO in the title

select title
from film
WHERE title REGEXP 'apollo';

#Get all films which title ends with APOLLO.
select title
from film
WHERE title REGEXP 'apollo$';

#Get all films with word DATE in the title.
select title
from film
WHERE title REGEXP 'date';

#Get 10 films with the longest title.

select title
from film
order by length(title) DESC
LIMIT 10;

#Get 10 the longest films.
select title, length
from film
order by length desc
limit 10;

#How many films include Behind the Scenes content?

select count(title)
from film
WHERE special_features REGEXP 'behind';

#List films ordered by release year and title in alphabetical order.

select title, release_year
from film
order by release_year desc, title asc;

#Drop column picture from staff.

ALTER TABLE staff
DROP COLUMN picture;

#A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
INSERT INTO staff(staff_id, first_name, last_name, address_id, store_id, username)
VALUES (3, 'Tammy', 'Sanders', 4, 2, 'friedchicken');

select *
from rental;
#21. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
#You can use current date for the rental_date column in the rental table. 
#Hint: Check the columns in the table rental and see what information you would need to add there. 

INSERT INTO rental(rental_id, rental_date, inventory_id, customer_id, staff_id)
VALUES(16050,"2005-08-23 22:50:12", 1, (select customer_id from customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER' LIMIT 1), (select staff_id from staff
where first_name = "MIKE" and last_name = "HILLYER" LIMIT 1));
 

####You can query those pieces of information. For eg., you would notice that you need customer_id information as well. 
####To get that you can use the following query:
####select customer_id from sakila.customer
####where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
####Use similar method to get inventory_id, film_id, and staff_id.

select *
from customer;

#22. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users 
#that would be deleted. Follow these steps:

CREATE TABLE backup_table
AS SELECT  *
FROM customer
WHERE active = 0;

DELETE FROM customer
WHERE active = 0;


#Check if there are any non-active users
##Create a table backup table as suggested
##Insert the non active users in the table backup table
##Delete the non active users from the table customer