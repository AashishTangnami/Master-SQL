/*
The following query will create new temporary tables in the ecommerce_schema database.
The tables will be used to store the data from the CSV files.
There are other ways to import data into a database.
*/

CREATE TABLE ecommerce_schema.temp_order_items (
    order_id INTEGER,
    order_item_id INTEGER,
    product_id VARCHAR(255),
    shipping_limit_date TEXT,
    price NUMERIC,
    freight_value NUMERIC
);

CREATE TABLE IF NOT EXISTS ecommerce_schema.temp_order_items(
	order_id varchar(32),
	order_item_id integer,
	product_id varchar(32) REFERENCES ecommerce_schema.products(product_id),
	shipping_limit_date TEXT,
	price float,
	freight_value float,
	PRIMARY KEY (order_id, order_item_id)
);


INSERT INTO ecommerce_schema.order_items (order_id, order_item_id, product_id, shipping_limit_date, price, freight_value)
SELECT 
    order_id,
    order_item_id,
    product_id,
    -- Changed the timestamp format to 'DD/MM/YYYY HH24:MI' 
    TO_TIMESTAMP(shipping_limit_date, 'DD/MM/YYYY HH24:MI'),
    price,
    freight_value
FROM ecommerce_schema.temp_order_items;

/*
The following COPY query will import the data from the CSV file into the desired table.

*/
COPY ecommerce_schema.temp_order_items (order_id, order_item_id, product_id, shipping_limit_date, price, freight_value)
FROM '/Users/aashishtangnami/Downloads/Master-SQL-for-Data-Analysis/Level_2_Resources/Datasets/ecommerce/order_items.csv'
DELIMITER ',' CSV HEADER QUOTE '''' ESCAPE '"';

DROP TABLE ecommerce_schema.temp_order_items;


CREATE TABLE ecommerce_schema.temp_orders(
	order_id varchar(32) PRIMARY KEY, 
	customer_id varchar(32) REFERENCES ecommerce_schema.customers(customer_id),
	order_status varchar(20),
	order_purchase_timestamp text,
	order_delivered_customer_date text,
	order_estimated_delivery_date text
);

INSERT INTO ecommerce_schema.orders (order_id, customer_id, order_status, order_purchase_timestamp, order_delivered_customer_date, order_estimated_delivery_date)
SELECT 
    order_id,
    customer_id,
    order_status,
    TO_TIMESTAMP(order_purchase_timestamp, 'DD/MM/YYYY HH24:MI'),
	TO_TIMESTAMP(order_delivered_customer_date, 'DD/MM/YYYY HH24:MI'),
	TO_TIMESTAMP(order_estimated_delivery_date, 'DD/MM/YYYY HH24:MI')
FROM ecommerce_schema.temp_orders;

DROP TABLE ecommerce_schema.temp_orders;

CREATE TABLE ecommerce_schema.temp_order_reviews(
	review_id integer PRIMARY KEY,
	order_id varchar(32) REFERENCES ecommerce_schema.orders(order_id),
	review_score smallint,
	review_creation_date text
);

INSERT INTO ecommerce_schema.order_reviews (review_id, order_id, review_score, review_creation_date)
SELECT 
    review_id,
    order_id,
    review_score,
    TO_TIMESTAMP(review_creation_date, 'DD/MM/YYYY HH24:MI')
FROM ecommerce_schema.temp_order_reviews;

DROP TABLE ecommerce_schema.temp_order_reviews;

/*
Combine ouputs of select statements
	dropping duplicates

Syntax:
	SELECT column_names FROM table_1
	UNION
	SELECT column_names FROM table_2;

Queries must have the same structure
	Number of columns
	Columns data types
	Order
*/

-- ALTER TABLE ecommerce_schema.customers RENAME COLUMN vustomer_state TO customer_state ;

SELECT customer_state, count(distinct customer_city) as amount_cities
FROM ecommerce_schema.customers
GROUP by customer_state
ORDER BY 2;


SELECT DISTINCT customer_city FROM ecommerce_schema.customers WHERE customer_state = 'CE'

SELECT DISTINCT supplier_city FROM ecommerce_schema.suppliers WHERE supplier_state = 'CE'

----- UNION OPERATOR ------ 
SELECT DISTINCT customer_city FROM ecommerce_schema.customers WHERE customer_state = 'CE'
UNION 
SELECT DISTINCT supplier_city FROM ecommerce_schema.suppliers WHERE supplier_state = 'CE';
-- RESULTS 162 ROWS

---- INTERSECT OPERATORS -----
SELECT DISTINCT customer_city FROM ecommerce_schema.customers WHERE customer_state = 'CE'
INTERSECT 
SELECT DISTINCT supplier_city FROM ecommerce_schema.suppliers WHERE supplier_state = 'CE';
-- RESULTS 6 ROWS


------ EXCEPT OPERATOR -------
------ A-B --------
/*
 DISTINCT ROWS FROM THE FIRST TABLE : A-B
 RESULTS ONLY REMAINING VALUES IN A WHICH DO NOT INTERSECT WITH B.
 SYNTAX:
 	SELECT column_name FROM table1
	 EXCEPT
	 SELECT column_name FROM table2;
*/

SELECT DISTINCT customer_city FROM ecommerce_schema.customers WHERE customer_state = 'CE'
EXCEPT 
SELECT DISTINCT supplier_city FROM ecommerce_schema.suppliers WHERE supplier_state = 'CE';

SELECT DISTINCT supplier_city FROM ecommerce_schema.suppliers WHERE supplier_state = 'CE'
EXCEPT 
SELECT DISTINCT customer_city FROM ecommerce_schema.customers WHERE customer_state = 'CE';

/*

JOIN

combine data from multiple unidentical tables
Join Types: Inner, Outer, Cross-join.
A Joined table
	- Derived from two tables based on the specific join type

Syntax:
	 From table1 join_type table2 [join_condition]
	 from table1 join_type table2 [join_condition] table3 join_type [joinK_condition]


Cartesian Join / Cross-join
	Syntax:
		table_1 CROSS JOIN table_2

Joined table:
	each row columns from table1 columns from table2.
*/
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

/*
MOST FREQUENTLY USED JOIN-TYPE
A join operation that is based on a condition.
	- Select records with matching values in both tables
	- Using relational links between tables.

Syntax:
	 SELECT [list of columns from both tables]
	 FROM table1 INNER JOIN table2 ON [join condition]

Better to qualify the table names
	SELECT table1.column_x, table2.column_y
	
*/

/*
Inner Join
-- List of customers, list of orders --> connection is customer_id
-- Get the list of orders with the customer information.
*/

SELECT o.order_id, o.order_status, c.customer_id, c.customer_city
FROM ecommerce_schema.customers as c
INNER JOIN ecommerce_schema.orders as o ON c.customer_id = o.customer_id;


get the list of items per each order (using the order_id)
SELECT o.order_id , o.customer_id, o.order_status, oi.order_item_id, oi.price
FROM ecommerce_schema.orders as o
INNER JOIN ecommerce_schema.order_items as oi  ON o.order_id = oi.order_id
ORDER BY o.order_id

SELECT o.order_id , o.customer_id, c.customer_name, c.customer_state, o.order_status, oi.order_item_id, oi.price
FROM ecommerce_schema.customers as c
INNER JOIN ecommerce_schema.orders as o ON c.customer_id = o.customer_id
INNER JOIN ecommerce_schema.order_items as oi  ON o.order_id = oi.order_id
ORDER BY oi.price DESC

/*
OUTER JOIN
	SYNTAX:- Preserves unmatched rows from one of the tables.
	Types:
		- LEFT, RIGHT AND FULL
	- LEFT OUTER JOIN
		- All records from the left table (table1) and only the matched records from the right table(table2)
		- Table 1= 10K, Table 2 = 5k -> Output 10K.
		- Matching rows will have columns values from table 2
		
*/



------------------ Left Outer Join ---------------------
SELECT c.customer_id, c.customer_name, c.customer_city, o.order_id, o.order_status
FROM ecommerce_schema.customers as c
LEFT JOIN ecommerce_schema.orders as o ON c.customer_id = o.customer_id
WHERE customer_city = 'franca' IS NOT NULL
ORDER BY 3 DESC;

------------------ Compare to Inner Join ---------------------
SELECT c.customer_id, c.customer_name, c.customer_city, o.order_id, o.order_status
FROM ecommerce_schema.customers as c
INNER JOIN ecommerce_schema.orders as o ON c.customer_id = o.customer_id
WHERE customer_city = 'franca' IS NOT NULL


/*
Queries records when there is a match in left or right table records.
Three steps:
	- An inner join is performed, matching rows based on a condition.
	- For each row in table1 that does not satisfy the join condition with any row in table2, a joined 
	 	row is added with null values in columns of table 2
	- And the third step, for each row of table 2 that does not satisfy the join condition with any row 
		in table 1, a joined row with null values in the colunms of table 1 is added.
		
*/

SELECT c.customer_id, c.customer_name, c.customer_city, o.order_id, o.order_status
FROM ecommerce_schema.customers AS c
full OUTER JOIN ecommerce_schema.orders AS o ON c.customer_id = o.customer_id
WHERE c.customer_city = 'franca' OR o.customer_id IS NULL
ORDER BY c.customer_city DESC;