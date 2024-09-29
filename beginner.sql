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
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- LEVEL 1
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
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


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
------------------------------------- LEVEL 2 ---------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

PostgresSQL
	- DBMS for the training

Datasets
	- eCommerce store
	- Books rating
/*
(options: S = show system objects, + = additional detail)
  \d[S+]                 list tables, views, and sequences
  \d[S+]  NAME           describe table, view, sequence, or index
  \da[S]  [PATTERN]      list aggregates
  \dA[+]  [PATTERN]      list access methods
  \dAc[+] [AMPTRN [TYPEPTRN]]  list operator classes
  \dAf[+] [AMPTRN [TYPEPTRN]]  list operator families
  \dAo[+] [AMPTRN [OPFPTRN]]   list operators of operator families
  \dAp[+] [AMPTRN [OPFPTRN]]   list support functions of operator families
  \db[+]  [PATTERN]      list tablespaces
  \dc[S+] [PATTERN]      list conversions
  \dconfig[+] [PATTERN]  list configuration parameters
  \dC[+]  [PATTERN]      list casts
  \dd[S]  [PATTERN]      show object descriptions not displayed elsewhere
  \dD[S+] [PATTERN]      list domains
  \ddp    [PATTERN]      list default privileges
  \dE[S+] [PATTERN]      list foreign tables
  \des[+] [PATTERN]      list foreign servers
  \det[+] [PATTERN]      list foreign tables
  \deu[+] [PATTERN]      list user mappings
  \dew[+] [PATTERN]      list foreign-data wrappers
  \df[anptw][S+] [FUNCPTRN [TYPEPTRN ...]]
                         list [only agg/normal/procedure/trigger/window] functions
  \dF[+]  [PATTERN]      list text search configurations
  \dFd[+] [PATTERN]      list text search dictionaries
  \dFp[+] [PATTERN]      list text search parsers
  \dFt[+] [PATTERN]      list text search templates
  \dg[S+] [PATTERN]      list roles
  \di[S+] [PATTERN]      list indexes
  \dl[+]                 list large objects, same as \lo_list
  \dL[S+] [PATTERN]      list procedural languages
  \dm[S+] [PATTERN]      list materialized views
  \dn[S+] [PATTERN]      list schemas
  \do[S+] [OPPTRN [TYPEPTRN [TYPEPTRN]]]
                         list operators
  \dO[S+] [PATTERN]      list collations
  \dp[S]  [PATTERN]      list table, view, and sequence access privileges
  \dP[itn+] [PATTERN]    list [only index/table] partitioned relations [n=nested]
  \drds [ROLEPTRN [DBPTRN]] list per-database role settings
  \drg[S] [PATTERN]      list role grants
  \dRp[+] [PATTERN]      list replication publications
  \dRs[+] [PATTERN]      list replication subscriptions
  \ds[S+] [PATTERN]      list sequences
  \dt[S+] [PATTERN]      list tables
  \dT[S+] [PATTERN]      list data types
  \du[S+] [PATTERN]      list roles
  \dv[S+] [PATTERN]      list views
  \dx[+]  [PATTERN]      list extensions
  \dX     [PATTERN]      list extended statistics
  \dy[+]  [PATTERN]      list event triggers
  \l[+]   [PATTERN]      list databases
  \sf[+]  FUNCNAME       show a function's definition
  \sv[+]  VIEWNAME       show a view's definition
  \z[S]   [PATTERN]      same as \dp

Large Objects
  \lo_export LOBOID FILE write large object to file
  \lo_import FILE [COMMENT]
                         read large object from file
  \lo_list[+]            list large objects
  \lo_unlink LOBOID      delete a large object

Formatting
  \a                     toggle between unaligned and aligned output mode
  \C [STRING]            set table title, or unset if none
  \f [STRING]            show or set field separator for unaligned query output
  \H                     toggle HTML output mode (currently off)
  \pset [NAME [VALUE]]   set table output option
                         (border|columns|csv_fieldsep|expanded|fieldsep|
                         fieldsep_zero|footer|format|linestyle|null|
                         numericlocale|pager|pager_min_lines|recordsep|
                         recordsep_zero|tableattr|title|tuples_only|
                         unicode_border_linestyle|unicode_column_linestyle|
                         unicode_header_linestyle)
  \t [on|off]            show only rows (currently off)
  \T [STRING]            set HTML <table> tag attributes, or unset if none
  \x [on|off|auto]       toggle expanded output (currently off)

Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
  \conninfo              display information about current connection
  \encoding [ENCODING]   show or set client encoding
  \password [USERNAME]   securely change the password for a user

Operating System
  \cd [DIR]              change the current working directory
  \getenv PSQLVAR ENVVAR fetch environment variable
  \setenv NAME [VALUE]   set or unset environment variable
  \timing [on|off]       toggle timing of commands (currently off)
  \! [COMMAND]           execute command in shell or start interactive shell

Variables
  \prompt [TEXT] NAME    prompt user to set internal variable
  \set [NAME [VALUE]]    set internal variable, or list all if no parameters
  \unset NAME            unset (delete) internal variable

*/




