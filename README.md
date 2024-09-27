# Master SQL for Data Science

## Course Overview
This course is designed to help you master SQL for data science applications. It covers essential SQL concepts and techniques specifically tailored for data analysis and manipulation.

## Course Contents

### Section 1: Introduction to SQL for Data Science
- Basic SQL syntax
- Querying databases
- Data types in SQL

### Section 2: Advanced SQL Techniques
- Joins and subqueries
- Window functions
- Aggregations and grouping

### Section 3: Data Manipulation and Analysis
- Data cleaning with SQL
- Complex data transformations
- Statistical functions in SQL

### Section 4: Optimizing SQL for Data Science
- Query optimization techniques
- Indexing for performance
- Handling large datasets

## Prerequisites
- Basic understanding of databases
- Familiarity with data analysis concepts

## Learning Outcomes
By the end of this course, you will be able to:
- Write complex SQL queries for data analysis
- Perform advanced data manipulations using SQL
- Optimize SQL queries for better performance
- Apply SQL in real-world data science scenarios

## Tools and Technologies
- SQL Server
- PostgreSQL
- Jupyter Notebooks for SQL

## How to Use This Course
- Follow the sections in order
- Complete all exercises and projects
- Practice regularly with provided datasets

## Additional Resources
- Course slides and notes
- Sample datasets for practice
- Recommended reading list

---

## SQL Code Snippets

```sql
-- COPY command for PostgreSQL
\copy your_table_name FROM '/Users/Downloads/titles.csv' WITH (FORMAT csv, HEADER);

COPY netflix.titles(title_id, title, title_type, description, release_year, 
                   age_certification, runtime, genres, production_countries, 
                   seasons, imdb_score, imdb_votes)
FROM '/Users/aashishtangnami/Downloads/titles.csv' WITH (FORMAT CSV, HEADER);

COPY netflix.credits(person_id, title_id, name, character, role) 
FROM '/Users/aashishtangnami/Downloads/credits.csv'
DELIMITER ',' CSV HEADER;

-- Altering the column type
ALTER TABLE netflix.titles ALTER COLUMN release_year TYPE integer;

-- Updating a column with specific attribute value
UPDATE products SET price = 15 WHERE price > 10;

-- Renaming a column
ALTER TABLE products RENAME COLUMN product_no TO product_number;

-- Adding a column
ALTER TABLE products ADD COLUMN description VARCHAR(10);

-- Deleting rows based on a condition
DELETE FROM products WHERE price > 200;

-- Deleting all rows
DELETE FROM products;

-- Deleting a column
ALTER TABLE products DROP COLUMN description;

-- Deleting an entire table
DROP TABLE products;

-- Querying data
SELECT * FROM netflix.titles;

SELECT product_num, price * 1.05 FROM product;
SELECT product_num, ROUND(price * 1.05, 2) FROM product;

-- Using LIMIT for outputting limited data
SELECT * FROM netflix.titles LIMIT 10;

-- Filtering on a single condition
SELECT title, title_type FROM netflix.titles WHERE title_type = 'movie';

-- Filtering values of range
SELECT title, title_type, release_year FROM netflix.titles WHERE release_year BETWEEN 1980 AND 1990;

-- Querying NULL values
SELECT title, title_type, seasons FROM netflix.titles WHERE seasons IS NULL;

-- Querying NOT NULL values
SELECT title, title_type, seasons FROM netflix.titles WHERE seasons IS NOT NULL;

-- Using AND operator for multiple conditions
SELECT title, title_type, release_year, runtime 
FROM netflix.titles 
WHERE title_type = 'Movie' 
AND release_year BETWEEN 1980 AND 1990 
AND runtime > 100;

-- Using OR operator for multiple conditions
SELECT title, title_type, release_year, runtime 
FROM netflix.titles 
WHERE release_year BETWEEN 1980 AND 1990 
OR runtime > 100;

-- Using alias for columns and tables
SELECT title, title_type, runtime AS movie_length, (release_year + 1) AS updated_year
FROM netflix.titles;

-- Alias for tables
SELECT t1.title, t1.title_type, t1.runtime 
FROM netflix.titles AS t1, netflix.credits AS t2;

-- Searching with wildcards
SELECT title, title_type 
FROM netflix.titles 
WHERE title LIKE 'The%';

SELECT title, title_type 
FROM netflix.titles 
WHERE title LIKE '_a%ver';

-- Querying distinct values
SELECT DISTINCT age_certification FROM netflix.titles WHERE age_certification IS NOT NULL;

-- Counting distinct values
SELECT COUNT(DISTINCT age_certification) AS unique_age_certifications 
FROM netflix.titles WHERE age_certification IS NOT NULL;

-- Sorting rows
SELECT title, title_type FROM netflix.titles ORDER BY title_type DESC;

-- Grouping data
SELECT title_type, AVG(imdb_score) AS avg_score 
FROM netflix.titles 
WHERE release_year >= 2000 
GROUP BY title_type;

-- Combining data from two tables
SELECT c1.title_id, t1.title, COUNT(DISTINCT c1.person_id) AS unique_actors 
FROM netflix.credits AS c1, netflix.titles AS t1 
WHERE c1.role = 'Actor' 
AND c1.title_id = t1.title_id 
GROUP BY c1.title_id, t1.title 
ORDER BY unique_actors DESC;

-- Using HAVING with GROUP BY
SELECT title_type, release_year, MAX(imdb_score) AS max_imdb_score 
FROM netflix.titles 
GROUP BY title_type, release_year 
HAVING MAX(imdb_score) IS NOT NULL 
ORDER BY title_type, release_year;

-- Data type conversion (CAST)
SELECT CAST('2023-01-01' AS TIMESTAMP);

-- Querying the data dictionary
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;

SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS;

-- Conditional data dictionary check
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Album'
) 
SELECT 'found' AS search_result 
ELSE 
SELECT 'not found' AS search_result;
