/*
SQL-Subqueries

-- A subquery is a query within another query. 
    - The outer query is called as main query and inner query is called as subquery. 
- The subquery must be enclosed with parenthesis and generally executes first, 
    and its output is used to complete the query condition for the main query.

-- They are basically used to perform operate in multiple steps. 
    - The result of the inner query is passed on to the outer query.
    - Extract infromation from mulitple tables.
Subquery can be used in SELECT, INSERT, UPDATE, DELETE statements.


Types of Subqueries:
    - Single row with single column
    - Multiple rows with single column
    - Multiple rows with multiple columns

*/
 -- Single Row --
 -- Syntax:
    -- SELECT column_name 
    -- FROM table_name 
    -- WHERE column_name EXPRESSION_OPERATOR (SUBQUERY condition);

SELECT AVG(product_weight_g)
FROM ecommerce_schema.products ;

SELECT product_id, product_weight_g 
FROM ecommerce_schema.products 
WHERE product_weight_g >
    (
    SELECT AVG(product_weight_g)
    FROM ecommerce_schema.products 
    );

-- NOTES
/*
- A subquery must be enclosed in parenthesis.
- Must be placed in the right side of the comparison operator.
- THe operator in the where section must be compatible with the subquery result.
- A subquery with the aggregate function must return a single value.
- A subquery may reference the same table reference by the outer query.
- we should not include an alias for a subquery in a conditional statement.
*/

--- outer sub query
SELECT product_id, product_category_name, product_price
FROM ecommerce_schema.products

WHERE product_price = 
	( -- inner subquery
	SELECT MAX(product_price)
	FROM ecommerce_schema.products 
    );


------ A Subquery that returns multiple rows ------
-- Syntax:
    -- SELECT column_name 
    -- FROM table_name 
    -- WHERE EXPRESSION_OPERATOR IN (SUBQUERY condition);


-- The list of books with an average rating score greater than 7.5 that were published.
SELECT DISTINCT isbn
FROM books_schema.ratings
GROUP BY 1
HAVING AVG(book_rating)>7.5;


---------- Multiple Columns ----------
SELECT isbn, book_title, year_of_publication
FROM books_schema.books2
WHERE 
    year_of_publication > 2000
    AND
    isbn 
    IN 
    (
        SELECT DISTINCT isbn
        FROM books_schema.ratings
        GROUP BY 1
        HAVING AVG(book_rating)>7.5
    );


---------- Using Inner Join ----------

SELECT b.isbn, b.book_title, b.year_of_publication
FROM books_schema.books2 AS b
INNER JOIN books_schema.ratings AS r ON b.isbn = r.isbn
WHERE 
    b.year_of_publication > 2000
GROUP BY 1,2,3
HAVING AVG(r.book_rating) = 9.5;
-----------  -----------
SELECT isbn
FROM books_schema.ratings
WHERE
 book_rating > 7 AND 
 user_id IN (
	SELECT user_id
	FROM books_schema.users
	WHERE country = 'usa' AND age > 16
 );
-----------   -----------
SELECT book_title
FROM books_schema.books2
WHERE isbn IN
 (
	SELECT isbn 
	FROM books_schema.ratings 
	WHERE
		book_rating > 7
	AND user_id
		IN (
		SELECT user_id FROM books_schema.users
		WHERE country = 'us' AND age > 16 
	)
 );
/*
-  The list of books that have a rating a greater or equal to 9.5.
- Those rating were provided by users living in the US.
- 
*/

SELECT isbn, avg(book_rating) as avg_rating
FROM books_schema.ratings
GROUP BY isbn;
----------- Inline View (From) -----------
SELECT MAX(avg_rating) as max_avg_rating 
FROM (
	SELECT isbn, avg(book_rating) as avg_rating
	FROM books_schema.ratings
	GROUP BY isbn
) as avg_books_ratings;

/*
SQL - Conditional Logics
CASE STATEMENT - It is used to evaluate a list of conditions and returns one of the multiple possible result expression.

    Case
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        Else result3
    END;
*/
----------- Simple Case Statement -----------
--- Syntax:
    -- SELECT column_name,
    -- CASE
    --     WHEN condition1 THEN result1
    --     WHEN condition2 THEN result2
    --     ELSE result3
    -- END as alias_name
    -- FROM table_name;

--- Typical use case is for data transformation.


SELECT user_id, age, country,
    CASE gender
        WHEN 'm' THEN 'Male'
        ELSE 'Female'
    END as gender
FROM books_schema.users;
-- Processing step:
   -- For every  row the Select statement receives, the case statement goes through conditions form top to bottom.
   -- Returns a value when the first condition is met.
   -- No conditions are true, it returns the value in the ELSE clause.
   -- No Else part and no conditions are ture, it return NULL.


----------- Searched Case Statement -----------
-- SYNTAX:
    -- CASE 
    --     WHEN condition1 THEN result1
    --     WHEN condition2 THEN result2
    --     ELSE result3
    -- END as alias_name


SELECT user_id, age, country,
    CASE 
        WHEN age < 16 THEN 'Child'
        WHEN age BETWEEN 16 AND 25 THEN 'Young Adult'
        WHEN age BETWEEN 26 AND 40 THEN 'Adult'
        ELSE 'Senior'
    END as age_category
FROM books_schema.users;

---- Typical use case is for data binding. ---
-- divide the products by their weight using the following binding groups: "Light", "Medium", "Heavy".
SELECT product_id, product_category_name,
    CASE
        WHEN product_weight_g <= 50 THEN 'Light'
        WHEN product_weight_g BETWEEN 50 AND 150 THEN 'Medium'
        ELSE 'Heavy'
    END as weight_category
FROM ecommerce_schema.products;

SELECT
    CASE
        WHEN product_weight_g <= 100 THEN 'Light'
        WHEN product_weight_g >= 100 AND product_weight_g <= 500 THEN 'Medium'
        ELSE 'Heavy'
    END as weight_category,
    COUNT (*) AS amount
FROM ecommerce_schema.products
GROUP BY 1;


/*
SQL - Window Functions

The average user age from the users table, grouped by city location.

    SELECT city, avg(age)
    FROM books_schema.users
    GROUP BY city;
    HAVING city IS NOT NULL


------ Window Function -----
OVER and PARTITION BY 

-- OVER - It defines a window or user-specified set of rows within a query result set.
        Transform the result set into a window function.

-- PARTITION BY - It divides the result set into partitions to which the window function is applied.    
    Divide the rows into groups (partitions) and apply the window function to each group.
*/

SELECT user_id, age, city, AVG(age) OVER (PARTITION BY city) as avg_age
FROM books_schema.users
WHERE city IS NOT NULL
ORDER BY 1 DESC; 

SELECT user_id, age, city, AVG(age) OVER (PARTITION BY city) as avg_age
FROM books_schema.users
WHERE city = "New York";

----- Window Function with Aggregate Function MAX partitioned by customers_state -----
SELECT c.customer_name, oi.price, o.order_status, MAX(oi.price) OVER (PARTITION BY c.customer_state) as max_price
FROM ecommerce_schema.customers AS c
INNER JOIN ecommerce_schema.orders AS o ON c.customer_id = o.customer_id
INNER JOIN ecommerce_schema.order_items AS oi ON o.order_id = oi.order_id
WHERE oi.price IS NOT NULL;


------------------------------- WINDOW FUNCTION - SEQUENTIAL NUMBERS -------------------------------
-- A Sequential number for each row inside a group of rows while we decide how this group will be ordered.
-- ROW_NUMBER() - Window function that assigns a unique sequential integer to each row within the partition of a result set.

-------- Oldest user per each city, meaning the first user per each city --------

SELECT *
FROM (
    SELECT city, user_id, age, ROW_NUMBER() OVER (PARTITION BY city ORDER BY age DESC) as row_num
    FROM books_schema.users

) AS t
WHERE row_num = 1;


SELECT *
FROM (
    SELECT city, user_id, age, ROW_NUMBER() OVER (PARTITION BY city ORDER BY age DESC) as row_num
    FROM books_schema.users

) AS t
WHERE row_num <= 5;


----------- CONDITION : WHAT IF TWO OR MORE ROWS SHARES THE SAME VALUE. -----------
SELECT *
FROM (
    SELECT city,
        user_id,
        age,
        RANK() OVER (PARTITION BY city ORDER BY age DESC) as rank_num
    FROM books_schema.users
) as T
ORDE BY city;
 
/*
SQL - Simplifying Complex Queries (VIEWS, CTEs)

- Views - A virtual table that is based on the result of a SELECT statement.
    - It is a stored SELECT statement that can be used as a table.
    - It is a way to store a query in the database.
    - It is a way to simplify complex queries.
    - It is a way to hide the complexity of the query.
    - It is a way to reuse the query.
    - It is a way to secure the data.
    - It is a way to improve performance.
    - It is a way to encapsulate

Virutal Tables 

*/
CREATE VIEW books_schema.users_vw AS 
 (
	SELECT user_id, age, country,
		CASE gender
			WHEN 'M' THEN 'Male'
			ELSE 'Female'
 		END AS gender
	FROM books_schema.users
 );

SELECT * FROM 
books_schema.users_vw;


CREATE VIEW books_schema.books_vw AS 
(
    SELECT * FROM books_schema.books1
    UNION
    SELECT * FROM books_schema.books2
 );
SELECT * FROM books_schema.books_vw;

DROP TABLE books_schema.books_vw;  -- it will throw error since the table is virtual.
DROP VIEW books_schema.books_vw;  -- it must drop the virtual view table.

/*
Common Table Expressions (CTEs)

-- CTE is a temporary result set that is defined within the execution of a single SQL statement.
-- we can reference within a select statement
-- Start with the keyword "with" followed by the CTE Expression to which we ca refer later ina query.
*/

--Defining the CTE
WITH avg_books_ratings_CTE 
AS (

    SELECT isbn, avg(book_rating) as avg_rating
    FROM books_schema.ratings
    GROUP BY isbn
)
-- Define the outer query referencing the CTE NAME
SELECT MAX(avg_rating) as max_avg_rating
FROM avg_books_ratings_CTE;


-- Define the CTE query
WITH cities_users_CTE
AS (
	SELECT city, user_id, age, ROW_NUMBER() OVER (PARTITION BY city ORDER BY age DESC) AS row_num
	FROM books_schema.users
)

-- Define the outer query referencing the CTE NAME

SELECT * 
FROM cities_users_CTE
WHERE row_num <= 5
ORDER BY city;

