USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`. 

SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in  upper case letters

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM actor;

-- 2a. Find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name

SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Create a column in the table actor named description and use the data type BLOB.

ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b. Delete the description column

ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS 'Count of the Last Name' 
FROM actor 
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors. 

SELECT last_name, COUNT(*) AS 'Count of the Last Name' 
FROM actor 
GROUP BY last_name 
HAVING count(*) >=2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor 
SET first_name = 'HARPO'
WHERE UPPER(First_name) = 'GROUCHO' AND UPPER(last_name) = 'WILLIAMS'; 

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO

UPDATE actor 
SET first_name = 'GROUCHO'
WHERE UPPER(First_name) = 'HARPO' AND UPPER(last_name) = 'WILLIAMS'; 

-- 5a. Re-create the address table

SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address.

SELECT staff.first_name, staff.last_name, address.address
FROM staff  
INNER JOIN address
ON staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 

SELECT staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff 
INNER JOIN payment 
ON staff.staff_id = payment.staff_id 
AND DATE(payment.payment_date) LIKE '2005-08%'; 

-- 6c.List each film and the number of actors who are listed for that film.

SELECT film.title as 'Film Title', COUNT(film_actor.actor_id) as 'Number of Actors'
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system

SELECT COUNT(*) AS 'Copy Number of Hunchback Impossible'
FROM inventory
WHERE film_id IN 
(
	SELECT film_id 
	FROM film 
	WHERE UPPER(title) = 'HUNCHBACK IMPOSSIBLE'
);

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name

SELECT customer.first_name, customer.last_name, sum(payment.amount) AS 'Total Amount Paid'
FROM customer 
JOIN payment 
ON customer.customer_id= payment.customer_id
GROUP BY payment.customer_id
ORDER BY customer.last_name;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN 
(
	SELECT language_id 
	FROM language 
	WHERE name = 'English'
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	Select actor_id
	FROM film_actor
	WHERE film_id IN 
	(
		SELECT film_id
		FROM film
		WHERE UPPER(title) = 'ALONE TRIP'
	)
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT customer.first_name, customer.last_name, customer.email 
FROM customer 
INNER JOIN address  
ON (customer.address_id = address.address_id)
INNER JOIN city 
ON (city.city_id = address.city_id)
INNER JOIN country
ON (country.country_id = city.country_id)
WHERE UPPER(country.country)= 'CANADA';

-- 7d. Identify all movies categorized as family films.

SELECT title, description FROM film 
WHERE film_id IN
(
	SELECT film_id FROM film_category
	WHERE category_id IN
	(
		SELECT category_id FROM category
		WHERE name = "Family"
	)
);

-- 7e. Display the most frequently rented movies in descending order.

SELECT film.title, COUNT(rental.rental_id) as 'Rental Count'
FROM rental
INNER JOIN inventory
ON (rental.inventory_id = inventory.inventory_id)
INNER JOIN film
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, SUM(payment.amount) AS 'Total Revenue'
FROM payment 
INNER JOIN rental 
ON (rental.rental_id = payment.rental_id)
INNER JOIN inventory 
ON (inventory.inventory_id = rental.inventory_id)
INNER JOIN store 
ON (store.store_id = inventory.store_id)
GROUP BY store.store_id; 

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT store.store_id, city.city, country.country 
FROM store 
JOIN address 
ON (address.address_id = store.address_id)
JOIN city 
ON (city.city_id = address.city_id)
JOIN country
ON (country.country_id = city.country_id);

-- 7h. List the top five genres in gross revenue in descending order.

SELECT category.name AS 'GENRE', SUM(payment.amount) AS 'Total Revenue'
FROM payment
JOIN rental 
ON (rental.rental_id = payment.rental_id) 
JOIN inventory
ON (inventory.inventory_id = rental.inventory_id)
JOIN film_category
ON (film_category.film_id = inventory.inventory_id)
JOIN category
ON (category.category_id = film_category.category_id)
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8a. Use the solution from the problem above to create a view.

CREATE VIEW top_five_genres AS
SELECT category.name AS 'GENRE', SUM(payment.amount) AS 'Total Revenue'
FROM payment
JOIN rental 
ON (rental.rental_id = payment.rental_id) 
JOIN inventory
ON (inventory.inventory_id = rental.inventory_id)
JOIN film_category
ON (film_category.film_id = inventory.inventory_id)
JOIN category
ON (category.category_id = film_category.category_id)
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8b. Display the View

SELECT * FROM top_five_genres;

-- 8c. 

DROP VIEW top_five_genres;

