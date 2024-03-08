-- Lab 5 Unit 6

/*
Instructions

Write queries, stored procedures to answer the following questions:

1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
Convert the query into a simple stored procedure. Use the following query:

  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;

2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it 
can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
For eg., it could be action, animation, children, classics, etc.

3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter 
only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
*/

-- 1. 

delimiter //
create procedure customers_rented_actionmovies()
begin
select first_name, last_name, email from sakila.customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = 'Action'
group by first_name, last_name, email;
end //
delimiter ;

-- 2. 

delimiter //
create procedure customers_rented_actionmovies_dynamic(in category_name varchar(20))
begin
set category_name = coalesce(category_name, '');
select first_name, last_name, email from sakila.customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = category_name
group by first_name, last_name, email;
end //
delimiter ;

call customers_rented_actionmovies_dynamic('Animation');

-- 3.

select category.name as category_name, count(distinct film.film_id) as num_movies from sakila.category
join sakila.film_category on category.category_id = film_category.category_id
join sakila.film on film_category.film_id = film.film_id
group by category.name;

delimiter //
create procedure filter_categories_by_movie_count(in min_movie_count int)
begin
select category.name as category_name, count(distinct film.film_id) as num_movies from sakila.category
join sakila.film_category on category.category_id = film_category.category_id
join sakila.film on film_category.film_id = film.film_id
group by category.name
having num_movies > min_movie_count;
end //
delimiter ;

call filter_categories_by_movie_count(50); -- used minimum of 50 as an example