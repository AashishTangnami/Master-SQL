/* COPY COMMAND IN POSTGRESQL */
/* Make sure column names in table and column names in any file being imported must match */
-- \copy your_table_name FROM '/Users/Downloads/titles.csv' WITH (FORMAT csv, HEADER);


-- COPY netflix.titles(title_id, title, 
-- 	title_type, description, release_year, 
-- 	age_certification, runtime, genres, 
-- 	production_countries, seasons, 
-- 	imdb_score, imdb_votes)
-- FROM '/Users/Downloads/titles.csv' WITH (FORMAT CSV, HEADER);

/*
COPY netflix.credits(person_id, title_id, name, character, role) 
FROM '/Users/Downloads/credits.csv'
DELIMITER ','
CSV HEADER;
 */


 -- ALTER TABLE netflix.titles ALTER COLUMN release_year TYPE integer;


-- updating a column with specific attribute value (rows).
UPDATE products SET price = 15 WHERE price > 10;
-- renaming the column
ALTER TABLE products RENAME product_no TO product_number;
-- adding table row 
ALTER TABLE products AND COLUMN description varchar(10);
-- delteing rows
DELETE FROM products WHERE price> 200;

-- deleting all rows
DELETE FROM products;
-- deleting a column
ALTER TABLE products DROP column description;

-- deleting entire table.
DROP TABLE products;




-- QUERYING DATA
SELECT * FROM netflix.titles

SELECT product_num, price * 1.05 FROM product;
SELECT product_num, ROUND(price * 1.05, 2) FROM product;

-- Identifiers- required columns and tables.
SELECT required_cols FROM required_tables;

-- A quoted identifier - used when there are special cases in column namespace which is automatically case sensitive.
SELECT 'product number' (case sensitive)

-- LIMIT
select col1 from table1 limit num_of_record

------------------------
select * from netflix.titles limit 10 -- this must ouput only 10 data.


--Filtering on a single condition

-- Quries values that matches the title type
select title, title_type from table1 where title_type = 'movie' ;
-- Queries values that does not match the title type.
select title, title_type from table1 where title_type <> 'movie' ;

-- Queries values of range. lower values and upper limits are inclusive to the data output.
select title, title_type, release_year from table1 where release_year Between 1980 and 1990;


-- Query all the null values based on season column.
select title, title_type, seasons from table1 where seasons IS NULL
-- query all the not null values based on season column.
select title, title_type, seasons from table1 where seasons IS NOT NULL


/*
Complex filtering or multiple conditions
*/


-- Query with multiple conditions using AND operator.
SELECT title, title_type, release_year, runtime 
FROM table1 
WHERE 
	title_type = 'Movie' 
	AND release_year Between 1980 and 1990
	AND runtime > 100 ;


	
-- Query with multiple conditions using OR operator.

SELECT 
	col1, col2, col3 
FROM 
	table1 
WHERE 
	condition1 OR condition2


SELECT title, title_type, release_year, runtime 
FROM table1 
WHERE 
	release_year Between 1980 and 1990
	OR runtime > 100 ;


-- Order of Operations
-- Use parenthesis to separate queries.
-- In the following query 
SELECT 
	col1, col2, col3 
FROM 
	table1 
WHERE 
	condition1 AND (condition2 OR condition3)


-- Query using IN

SELECT 
	col1, col2, col3 
FROM 
	table1 
WHERE 
	condition1 AND (value1, value2, ... valuen)

-- Using Alias for Columns
SELECT title, title_type, runtime AS movie_length, (release_year + 1) AS updated_year
FROM netflix.titles

-- Alias for Tables - its useful while querying and joining multiple tables.
SELECT t1.title, title_type, runtime
FROM netflix.titles AS t1, netflix.credits AS t2


-------------------------------------------

/*
Searching Patterns (Wildcards and LIKE )

Wildcards:
	underscore(_) - one character
	Percent (%) - Any number of character
	
*/
-- The following query must return all the titles with The.
-- Charcter or word that begins with the (prefix)% is returned.
SELECT title, title_type
FROM netflix.titles
WHERE 
	title LIKE 'The%'

--  The following query must return movie titles that has a as second character 
--  and then inbetween any charcter can be there but must end with ver at the end.

SELECT title, title_type
FROM netflix.titles
WHERE 
	title LIKE '_a%ver'

-- Query distinct or Unique values.
SELECT DISTINCT age_certification
FROM netflix.titles -- netflix is a schema and titles is a table.
WHERE age_certification IS NOT NULL

-- Query distinct multiple columns
SELECT DISTINCT col1, col2
FROM table1 -- netflix is a schema and titles is a table.
WHERE col1 IS NOT NULL


-- Query : Count distinct values
SELECT COUNT(DISTINCT column_1) AS unique_column_1
FROM schema.table1
WHERE column_1 IS NOT NULL
	-- ACCESS THE AGGREGATED VALUE AS alias ( unique_column_1 ) should return count.

-- Query : Sorting Rows
-- Sorts rows in ascending order by default if not specified for columns.
SELECT column_1, column_2 ...
FROM table_1
ORDER BY column_1, column_2, ... ASC 

-- Sort rows in descending order for selected columns
SELECT column_1, column_2 ...
FROM table_1
ORDER BY column_1, column_2, ... DESC 


-- Sorting rows with conditions.
SELECT column1, column2
FROM table1 
WHERE column3 = 'value' AND column_value IS NOT NULL
ORDER BY column_value DESC


/*
Filtering the values in columns by grouping the rows for some conditions.
Use group by keywords to group the rows values in specific column.
*/

SELECT column_1
FROM table_1
WHERE condition_1
GROUP BY column_1
ORDER BY column_2


-- Single Column Grouping
SELECT title_type, AVG(imdb_score) AS avg_score
FROM netflix.title
WHERE release_year >= 2000
GROUP BY title_type

-- NOTE: group by column must be same as the selected column

SELECT title_id, COUNT(DISTINCT person_id) AS unique_actors 
FROM netflix.credits
WHERE role='ACTOR' 
GROUP BY title_id
ORDER BY DESC unique_actors


-- Combining data from two different tables.
select c1.title_id, t1.title, count(distinct c1.person_id) as unique_actors
from netflix.credits as c1, netflix.titles as t1
where
	role='Actor' and c1.title_id = t1.title_id
group by c1.title_id, t1.title
order by unique_actors desc

/*
Use of Halving.
Where - Filtering rows on the source tables
Having - filtering group-level aggregated rows created by the group by.
If there is any aggregated row, then we must use having for grouping rows.

*/


SELECT MAX() AS
FROM
GROUP BY
ORDER BY

SELECT title_type, release_year MAX(imdb_score) AS max_imdb_score -- two columns are being aggregated by max func of imdb_sorce column.    
FROM netflix.titles
GROUP BY title_type, release_year  -- selected column and group by column must match
HAVING MAX(imdb_score) IS NOT NULL
ORDER BY title_type, release_year;



/*

ORDER OF EXECUTION OF QUERIES

FROM >> WHERE >> GROUP BY >> HAVING >> SELECT >> ORDER BY

*/

-- DATA TYPE CONVERSION [ CAST ]

SELECT CAST('DATE VALUE' AS time_stamp) AS new_date


/*
DATA DICTIONARY -- 
IT IS USED TO AVOID RUNNING QUERIES MULTIPLE TIMES TO CHECK
IF THE SCHEMA NAME OR COLUMN NAME IS CORRECT.

USING INFROMATION_SCHEMA.(TABLES | COLUMNS) WE CAN RETRIEVE SPECIFIC DATA 

*/
-- QUERY TABLES IN THE DATABASE
SELECT
  	TABLE_NAME
FROM
  	INFORMATION_SCHEMA.TABLES


-- QUERY THE LIST OF COLUMNS AND TABLES IN THE DATABASE
SELECT
  	TABLE_NAME,
COLUMN_NAME
FROM
  	INFORMATION_SCHEMA.COLUMNS


-- QUERY THE COLUMNS FROM A SPECIFIC TABLE WITH THE NAME 'ALBUM'
SELECT
	COLUMN_NAME
FROM
  	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME = 'Album'

/* 
-- CONDITIONAL DATA DICITIONARY.
RETURN
	FOUND IF THE TABLE 'ALBUM EXISTS'

*/
IF EXISTS(
SELECT
  			*
  		FROM
  			INFORMATION_SCHEMA.TABLES
  		WHERE
  			TABLE_NAME = 'Album'
			)
SELECT 'found' AS search_result ELSE SELECT 'not found' AS search_result;




























