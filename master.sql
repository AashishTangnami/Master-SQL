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




/*
SQL - Conditional Logics
*/

/*
SQL - Window Functions
*/

/*
SQL - Simplifying Complex Queries (VIEWS, CTEs)
*/