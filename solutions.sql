USE SAKILA;

#How many distinct (different) actors' last names are there?
SELECT DISTINCT LAST_NAME FROM ACTOR;

#In how many different languages were the films originally produced? (Use the column language_id from the film table)
SELECT DISTINCT LANGUAGE_ID FROM FILM;

#How many movies were released with "PG-13" rating?
SELECT COUNT(FILM_ID) FROM FILM
WHERE RATING = "PG-13";

#Get 10 the longest movies from 2006.
SELECT DISTINCT LENGTH FROM FILM ORDER BY LENGTH DESC LIMIT 10;

#How many days has been the company operating (check DATEDIFF() function)?
SELECT CREATE_DATE FROM CUSTOMER ORDER BY CREATE_DATE ASC LIMIT 1;
SELECT DATEDIFF("2022-07-26 22:04:00", (SELECT CREATE_DATE FROM CUSTOMER ORDER BY CREATE_DATE ASC LIMIT 1));

#Show rental info with additional columns month and weekday. Get 20.
#SELECT *, RENTAL_DATE REGEXP '\d{4}-(\d{2})' FROM RENTAL LIMIT 20;
SELECT *, EXTRACT(MONTH FROM RENTAL_DATE) AS MONTH, DAYOFWEEK(RENTAL_DATE) AS WEEKDAY FROM RENTAL LIMIT 20;

#Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *, EXTRACT(MONTH FROM RENTAL_DATE) AS MONTH, DAYOFWEEK(RENTAL_DATE) AS WEEKDAY, 
(CASE 
	WHEN DAYOFWEEK(RENTAL_DATE) <6 THEN 'WEEKDAY'
    ELSE 'WEEKEND'
END) AS DAY_OF_WEEK
FROM RENTAL LIMIT 20;

#How many rentals were in the last month of activity?
SELECT RENTAL_DATE FROM RENTAL 
WHERE EXTRACT(MONTH FROM RENTAL_DATE) = EXTRACT(MONTH FROM LAST_UPDATE) 
AND EXTRACT(YEAR FROM RENTAL_DATE) = EXTRACT(YEAR FROM LAST_UPDATE);

#Get film ratings.
SELECT DISTINCT RATING FROM FILM;

#Get release years.
SELECT DISTINCT RELEASE_YEAR FROM FILM;

#Get all films with ARMAGEDDON in the title.
SELECT TITLE FROM FILM WHERE TITLE REGEXP "ARMAGEDDON";

#Get all films with APOLLO in the title
SELECT TITLE FROM FILM WHERE TITLE REGEXP "APOLLO";

#Get all films which title ends with APOLLO.
SELECT TITLE FROM FILM WHERE TITLE REGEXP "APOLLO$";

#Get all films with word DATE in the title.
#SELECT TITLE FROM FILM WHERE TITLE REGEXP "^DATE | DATE$|^DATE$";
SELECT TITLE FROM FILM WHERE TITLE REGEXP '\\bDATE\\b';

#Get 10 films with the longest title.
SELECT TITLE, LENGTH(TITLE) FROM FILM order by LENGTH(title) DESC limit 10;

#Get 10 the longest films.
SELECT TITLE FROM FILM order by LENGTH DESC limit 10;

#How many films include Behind the Scenes content?
SELECT COUNT(FILM_ID) FROM FILM WHERE SPECIAL_FEATURES REGEXP 'BEHIND THE SCENES';
# TEST
# SELECT SPECIAL_FEATURES FROM FILM WHERE SPECIAL_FEATURES REGEXP 'BEHIND THE SCENES';

#List films ordered by release year and title in alphabetical order.
SELECT TITLE FROM FILM ORDER BY RELEASE_YEAR AND TITLE ASC;

#Drop column picture from staff.
ALTER TABLE STAFF DROP COLUMN PICTURE;

#A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
SELECT * FROM STAFF WHERE FIRST_NAME='JON';
SELECT * FROM CUSTOMER WHERE FIRST_NAME='TAMMY';
INSERT INTO STAFF (STAFF_ID, FIRST_NAME, LAST_NAME, ADDRESS_ID, EMAIL, STORE_ID, ACTIVE, USERNAME, PASSWORD, LAST_UPDATE) VALUES (3,'TAMMY', 'SANDERS', 79, 'TAMMY.SANDERS@sakilacustomer.org', 2, 1, 'TAMMY', NULL, '2006-02-15 04:57:20');
# Can't add "MAX(STAFF_ID)+1" to staff_id and it doesn't auto-increment... trash.

#Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the 
#rental_date column in the rental table. Hint: Check the columns in the table rental and see what information you would need to 
#add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. 
#To get that you can use the following query:

#select customer_id from sakila.customer
#where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
#Use similar method to get inventory_id, film_id, and staff_id.

SELECT * FROM FILM WHERE TITLE='ACADEMY DINOSAUR';
SELECT * FROM CUSTOMER WHERE FIRST_NAME='charlotte';
SELECT * FROM STAFF WHERE FIRST_NAME='MIKE'; # AND LAST_NAME='HILLYER'

INSERT INTO RENTAL(rental_id, rental_date, inventory_id, customer_id, staff_id) VALUES
#((SELECT RENTAL_ID FROM RENTAL WHERE INVENTORY_ID = (SELECT INVENTORY_ID FROM INVENTORY WHERE FILM_ID = (SELECT FILM_ID 
#FROM FILM WHERE TITLE = "ACADEMY DINOSAUR" LIMIT 1) LIMIT 1)), 
(16050,
(SELECT CURRENT_TIMESTAMP()), 
(SELECT INVENTORY_ID FROM INVENTORY WHERE FILM_ID = (SELECT FILM_ID FROM FILM WHERE TITLE = "ACADEMY DINOSAUR" LIMIT 1) LIMIT 1),
(SELECT CUSTOMER_ID FROM CUSTOMER WHERE FIRST_NAME = 'CHARLOTTE' AND LAST_NAME = 'HUNTER' LIMIT 1), 
(SELECT STAFF_ID FROM STAFF WHERE STORE_ID = 1 LIMIT 1));

#Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users 
#that would be deleted. Follow these steps:

#Check if there are any non-active users
SELECT * FROM customer WHERE active = 0;

#Create a table backup table as suggested
CREATE TABLE backup_table;

#Insert the non active users in the table backup table
CREATE TABLE backup_table AS SELECT * FROM customer WHERE active = 0;

#Delete the non active users from the table customer
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM customer WHERE active = 0;
SET FOREIGN_KEY_CHECKS=1;