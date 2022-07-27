use sakila;

-- 1
select count(distinct(last_name))
from actor;

-- 2
select count(language_id)
from film;

-- 3
select count(film_id)
from film
where rating = "pg-13";

-- 4
select title, length
from film
where release_year = 2006
order by length desc
limit 10;

-- 5
select datediff(max(rental_date), min(rental_date)) 
from rental;

-- 6
select *, extract(month from rental_date) as month, dayofweek(rental_date) as weekday
from rental
limit 20;

-- 7
select *, extract(month from rental_date) as month, dayofweek(rental_date) as weekday, 
(case
when dayofweek(rental_date) < 6 then 'weekday'
else 'weekend'
end) as day_type
from rental
limit 20;

-- 8
select count(rental_id)
from rental
where (select extract(month from (rental_date))) = (select extract(month from (select rental_date from rental
order by rental_date desc
limit 1))) and (select extract(year from (rental_date)))=(select extract(year from (select rental_date from rental
order by rental_date desc
limit 1)));

-- 9
select distinct(rating)
from film;

-- 10
select distinct(release_year)
from film;

-- 11
select title
from film
where title regexp 'armageddon';

-- 12
select title
from film
where title regexp 'apollo';

-- 13
select title
from film
where title regexp 'apollo$';

-- 14
select title
from film
where title regexp ' date | date$|^date |^date$';
-- 15

select title
from film
order by length(title) desc
limit 10;

-- 16
select title
from film
order by length desc
limit 10;

-- 17
select count(film_id)
from film
where special_features regexp "behind";

-- 18
select title, release_year
from film
order by release_year, title asc;

-- 19
alter table staff
drop column picture;

-- 20
insert into staff(staff_id, first_name, last_name, address_id, store_id, username)
values (3, 'tammy', 'sanders', 4, 2, 'tammy');

-- 21
insert into rental(rental_id, rental_date, inventory_id, customer_id, staff_id)
values(
16050,
(select current_timestamp()),
(select inventory_id from inventory
where film_id = (select film_id from film where title = 'academy dinosaur' limit 1) limit 1),
(select customer_id from customer
where first_name = 'charlotte' and last_name = 'hunter' limit 1),
(select staff_id from staff
where store_id = 1 limit 1));

-- 22
create table backup_table
as select
*
from customer
where active = 0;

set foreign_key_checks=0;
delete from customer
where active = 0;
set foreign_key_checks=1;