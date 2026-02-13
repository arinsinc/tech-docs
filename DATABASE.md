# Database & SQL Tutorial

## Table of Contents
1. [Introduction to Databases](#introduction-to-databases)
2. [Database Fundamentals](#database-fundamentals)
3. [SQL Basics](#sql-basics)
4. [Creating and Managing Databases](#creating-and-managing-databases)
5. [Working with Tables](#working-with-tables)
6. [Data Manipulation (CRUD)](#data-manipulation-crud)
7. [Querying Data](#querying-data)
8. [Joins](#joins)
9. [Aggregate Functions](#aggregate-functions)
10. [Subqueries](#subqueries)
11. [Indexes](#indexes)
12. [Constraints](#constraints)
13. [Views](#views)
14. [Transactions](#transactions)
15. [Advanced Topics](#advanced-topics)
16. [Best Practices](#best-practices)

---

## Introduction to Databases

### What is a Database?
A database is an organized collection of structured data stored electronically in a computer system. Databases are managed by Database Management Systems (DBMS).

### Types of Databases
- **Relational Databases (RDBMS)**: MySQL, PostgreSQL, Oracle, SQL Server, SQLite
- **NoSQL Databases**: MongoDB, Cassandra, Redis
- **Cloud Databases**: Amazon RDS, Google Cloud SQL, Azure SQL

### Why Use Databases?
- Data persistence and storage
- Efficient data retrieval
- Data integrity and security
- Concurrent access by multiple users
- Backup and recovery

---

## Database Fundamentals

### Key Concepts

**Table**: A collection of related data organized in rows and columns
**Row (Record/Tuple)**: A single entry in a table
**Column (Field/Attribute)**: A specific piece of information in a table
**Primary Key**: A unique identifier for each record
**Foreign Key**: A reference to a primary key in another table
**Schema**: The structure or blueprint of a database

### ACID Properties
- **Atomicity**: Transactions are all-or-nothing
- **Consistency**: Data must meet all validation rules
- **Isolation**: Concurrent transactions don't interfere
- **Durability**: Committed changes are permanent

---

## SQL Basics

### What is SQL?
SQL (Structured Query Language) is a standard language for managing and manipulating relational databases.

### SQL Command Categories

**DDL (Data Definition Language)**
- CREATE, ALTER, DROP, TRUNCATE

**DML (Data Manipulation Language)**
- SELECT, INSERT, UPDATE, DELETE

**DCL (Data Control Language)**
- GRANT, REVOKE

**TCL (Transaction Control Language)**
- COMMIT, ROLLBACK, SAVEPOINT

---

## Creating and Managing Databases

### Create a Database
```sql
CREATE DATABASE company_db;
```

### List Databases
```sql
SHOW DATABASES;
```

### Select a Database
```sql
USE company_db;
```

### Drop a Database
```sql
DROP DATABASE company_db;
```

---

## Working with Tables

### Creating Tables

```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    salary DECIMAL(10, 2),
    department_id INT
);
```

### Common Data Types

**Numeric Types**
- INT, BIGINT, SMALLINT
- DECIMAL(p,s), NUMERIC(p,s)
- FLOAT, DOUBLE

**String Types**
- CHAR(n), VARCHAR(n)
- TEXT, BLOB

**Date and Time Types**
- DATE, TIME, DATETIME
- TIMESTAMP, YEAR

**Other Types**
- BOOLEAN
- JSON (in modern databases)

### Viewing Table Structure
```sql
DESCRIBE employees;
-- or
SHOW COLUMNS FROM employees;
```

### Altering Tables

```sql
-- Add a column
ALTER TABLE employees 
ADD phone_number VARCHAR(20);

-- Modify a column
ALTER TABLE employees 
MODIFY COLUMN salary DECIMAL(12, 2);

-- Drop a column
ALTER TABLE employees 
DROP COLUMN phone_number;

-- Rename a table
RENAME TABLE employees TO staff;
```

### Dropping Tables
```sql
DROP TABLE employees;
```

---

## Data Manipulation (CRUD)

### INSERT - Creating Data

**Insert Single Row**
```sql
INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id)
VALUES ('John', 'Doe', 'john.doe@company.com', '2024-01-15', 75000.00, 1);
```

**Insert Multiple Rows**
```sql
INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id)
VALUES 
    ('Jane', 'Smith', 'jane.smith@company.com', '2024-01-20', 80000.00, 2),
    ('Bob', 'Johnson', 'bob.johnson@company.com', '2024-02-01', 70000.00, 1),
    ('Alice', 'Williams', 'alice.williams@company.com', '2024-02-10', 85000.00, 3);
```

### SELECT - Reading Data

**Select All Columns**
```sql
SELECT * FROM employees;
```

**Select Specific Columns**
```sql
SELECT first_name, last_name, salary FROM employees;
```

**Using WHERE Clause**
```sql
SELECT * FROM employees 
WHERE salary > 75000;
```

**Using AND, OR, NOT**
```sql
SELECT * FROM employees 
WHERE salary > 70000 AND department_id = 1;

SELECT * FROM employees 
WHERE department_id = 1 OR department_id = 2;

SELECT * FROM employees 
WHERE NOT department_id = 3;
```

### UPDATE - Modifying Data

```sql
UPDATE employees 
SET salary = 82000.00 
WHERE employee_id = 2;

-- Update multiple columns
UPDATE employees 
SET salary = salary * 1.10, 
    email = 'newemail@company.com' 
WHERE employee_id = 1;
```

### DELETE - Removing Data

```sql
DELETE FROM employees 
WHERE employee_id = 5;

-- Delete all records (use with caution!)
DELETE FROM employees;
```

---

## Querying Data

### Filtering with WHERE

**Comparison Operators**
```sql
SELECT * FROM employees WHERE salary = 75000;
SELECT * FROM employees WHERE salary != 75000;
SELECT * FROM employees WHERE salary > 75000;
SELECT * FROM employees WHERE salary >= 75000;
SELECT * FROM employees WHERE salary < 75000;
SELECT * FROM employees WHERE salary <= 75000;
```

**BETWEEN**
```sql
SELECT * FROM employees 
WHERE salary BETWEEN 70000 AND 80000;
```

**IN**
```sql
SELECT * FROM employees 
WHERE department_id IN (1, 2, 3);
```

**LIKE (Pattern Matching)**
```sql
-- Starts with 'J'
SELECT * FROM employees 
WHERE first_name LIKE 'J%';

-- Ends with 'son'
SELECT * FROM employees 
WHERE last_name LIKE '%son';

-- Contains 'oh'
SELECT * FROM employees 
WHERE first_name LIKE '%oh%';

-- Second letter is 'o'
SELECT * FROM employees 
WHERE first_name LIKE '_o%';
```

**IS NULL / IS NOT NULL**
```sql
SELECT * FROM employees 
WHERE email IS NULL;

SELECT * FROM employees 
WHERE email IS NOT NULL;
```

### Sorting Results

```sql
-- Ascending order (default)
SELECT * FROM employees 
ORDER BY salary;

-- Descending order
SELECT * FROM employees 
ORDER BY salary DESC;

-- Multiple columns
SELECT * FROM employees 
ORDER BY department_id ASC, salary DESC;
```

### Limiting Results

```sql
-- First 5 records
SELECT * FROM employees 
LIMIT 5;

-- Skip 5, then get 10 records (pagination)
SELECT * FROM employees 
LIMIT 5 OFFSET 5;
-- or
SELECT * FROM employees 
LIMIT 5, 10;
```

### DISTINCT - Unique Values

```sql
SELECT DISTINCT department_id FROM employees;
```

---

## Joins

Joins combine rows from two or more tables based on related columns.

### Sample Tables for Joins

```sql
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments VALUES
    (1, 'Engineering', 'New York'),
    (2, 'Sales', 'Chicago'),
    (3, 'Marketing', 'Los Angeles'),
    (4, 'HR', 'Boston');
```

### INNER JOIN
Returns only matching records from both tables.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
```

### LEFT JOIN (LEFT OUTER JOIN)
Returns all records from the left table and matching records from the right table.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;
```

### RIGHT JOIN (RIGHT OUTER JOIN)
Returns all records from the right table and matching records from the left table.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;
```

### FULL OUTER JOIN
Returns all records when there's a match in either table.

```sql
-- MySQL doesn't support FULL OUTER JOIN directly, use UNION
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;
```

### CROSS JOIN
Returns the Cartesian product of both tables.

```sql
SELECT e.first_name, d.department_name
FROM employees e
CROSS JOIN departments d;
```

### SELF JOIN
Joining a table to itself.

```sql
-- Find employees in the same department
SELECT e1.first_name AS employee1, e2.first_name AS employee2
FROM employees e1
INNER JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.employee_id != e2.employee_id;
```

---

## Aggregate Functions

### Common Aggregate Functions

**COUNT**
```sql
SELECT COUNT(*) FROM employees;
SELECT COUNT(DISTINCT department_id) FROM employees;
```

**SUM**
```sql
SELECT SUM(salary) FROM employees;
```

**AVG**
```sql
SELECT AVG(salary) FROM employees;
```

**MIN and MAX**
```sql
SELECT MIN(salary) FROM employees;
SELECT MAX(salary) FROM employees;
```

### GROUP BY

```sql
SELECT department_id, COUNT(*) as employee_count, AVG(salary) as avg_salary
FROM employees
GROUP BY department_id;
```

### HAVING
Filter groups created by GROUP BY.

```sql
SELECT department_id, AVG(salary) as avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 75000;
```

### Complete Example

```sql
SELECT 
    d.department_name,
    COUNT(e.employee_id) as total_employees,
    AVG(e.salary) as average_salary,
    MIN(e.salary) as min_salary,
    MAX(e.salary) as max_salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 0
ORDER BY average_salary DESC;
```

---

## Subqueries

A subquery is a query nested inside another query.

### Subquery in WHERE Clause

```sql
-- Employees earning above average salary
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

### Subquery with IN

```sql
-- Employees in departments located in New York
SELECT first_name, last_name
FROM employees
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE location = 'New York'
);
```

### Subquery in FROM Clause (Derived Table)

```sql
SELECT dept_summary.department_id, dept_summary.avg_sal
FROM (
    SELECT department_id, AVG(salary) as avg_sal
    FROM employees
    GROUP BY department_id
) AS dept_summary
WHERE dept_summary.avg_sal > 75000;
```

### Correlated Subquery

```sql
-- Employees earning more than average in their department
SELECT e1.first_name, e1.last_name, e1.salary, e1.department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);
```

### EXISTS

```sql
-- Departments that have employees
SELECT department_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);
```

---

## Indexes

Indexes improve query performance by creating fast lookup structures.

### Creating Indexes

```sql
-- Simple index
CREATE INDEX idx_last_name ON employees(last_name);

-- Composite index
CREATE INDEX idx_name ON employees(last_name, first_name);

-- Unique index
CREATE UNIQUE INDEX idx_email ON employees(email);
```

### Viewing Indexes

```sql
SHOW INDEX FROM employees;
```

### Dropping Indexes

```sql
DROP INDEX idx_last_name ON employees;
```

### When to Use Indexes
- Columns frequently used in WHERE clauses
- Columns used in JOIN conditions
- Columns used in ORDER BY
- Foreign key columns

### When NOT to Use Indexes
- Small tables
- Columns with frequent updates
- Columns with low cardinality (few distinct values)

---

## Constraints

Constraints enforce rules on data in tables.

### PRIMARY KEY

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);
```

### FOREIGN KEY

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### UNIQUE

```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE
);
```

### NOT NULL

```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);
```

### CHECK

```sql
CREATE TABLE employees_new (
    employee_id INT PRIMARY KEY,
    age INT CHECK (age >= 18),
    salary DECIMAL(10,2) CHECK (salary > 0)
);
```

### DEFAULT

```sql
CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    title VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'draft'
);
```

### Adding Constraints to Existing Tables

```sql
-- Add foreign key
ALTER TABLE orders
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Add unique constraint
ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email);
```

---

## Views

Views are virtual tables based on SQL queries.

### Creating Views

```sql
CREATE VIEW employee_summary AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
```

### Using Views

```sql
SELECT * FROM employee_summary;

SELECT * FROM employee_summary
WHERE salary > 75000;
```

### Updating Views

```sql
CREATE OR REPLACE VIEW employee_summary AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    e.hire_date,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
```

### Dropping Views

```sql
DROP VIEW employee_summary;
```

---

## Transactions

Transactions ensure data integrity by grouping operations.

### Basic Transaction

```sql
START TRANSACTION;

UPDATE employees SET salary = 85000 WHERE employee_id = 1;
UPDATE employees SET salary = 90000 WHERE employee_id = 2;

COMMIT;
```

### ROLLBACK

```sql
START TRANSACTION;

DELETE FROM employees WHERE department_id = 3;

-- Oops, didn't mean to do that!
ROLLBACK;
```

### SAVEPOINT

```sql
START TRANSACTION;

UPDATE employees SET salary = salary * 1.10 WHERE department_id = 1;

SAVEPOINT sp1;

UPDATE employees SET salary = salary * 1.10 WHERE department_id = 2;

-- Rollback only the second update
ROLLBACK TO sp1;

COMMIT;
```

---

## Advanced Topics

### CASE Statements

```sql
SELECT 
    first_name,
    last_name,
    salary,
    CASE 
        WHEN salary < 70000 THEN 'Low'
        WHEN salary BETWEEN 70000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS salary_grade
FROM employees;
```

### String Functions

```sql
-- Concatenation
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employees;

-- Uppercase/Lowercase
SELECT UPPER(first_name), LOWER(last_name) FROM employees;

-- Substring
SELECT SUBSTRING(email, 1, 5) FROM employees;

-- Length
SELECT first_name, LENGTH(first_name) FROM employees;
```

### Date Functions

```sql
-- Current date and time
SELECT NOW(), CURDATE(), CURTIME();

-- Date arithmetic
SELECT hire_date, DATE_ADD(hire_date, INTERVAL 1 YEAR) FROM employees;

-- Date formatting
SELECT DATE_FORMAT(hire_date, '%M %d, %Y') FROM employees;

-- Extract parts
SELECT YEAR(hire_date), MONTH(hire_date), DAY(hire_date) FROM employees;
```

### Window Functions (Advanced)

```sql
-- Row number
SELECT 
    first_name,
    last_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as salary_rank
FROM employees;

-- Partition by
SELECT 
    first_name,
    last_name,
    department_id,
    salary,
    AVG(salary) OVER (PARTITION BY department_id) as dept_avg_salary
FROM employees;

-- Rank and Dense Rank
SELECT 
    first_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank
FROM employees;
```

### Common Table Expressions (CTE)

```sql
WITH high_earners AS (
    SELECT * FROM employees
    WHERE salary > 80000
)
SELECT 
    he.first_name,
    he.last_name,
    d.department_name
FROM high_earners he
INNER JOIN departments d ON he.department_id = d.department_id;
```

### Recursive CTE

```sql
WITH RECURSIVE employee_hierarchy AS (
    -- Base case
    SELECT employee_id, first_name, manager_id, 1 as level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case
    SELECT e.employee_id, e.first_name, e.manager_id, eh.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM employee_hierarchy;
```

---

## Best Practices

### Query Optimization
1. Use indexes on frequently queried columns
2. Avoid SELECT * - specify only needed columns
3. Use WHERE to filter data early
4. Use LIMIT when you don't need all results
5. Optimize JOIN conditions
6. Avoid functions on indexed columns in WHERE clauses

### Security
1. **Use parameterized queries** to prevent SQL injection
2. Grant minimum necessary privileges
3. Encrypt sensitive data
4. Regularly backup your database
5. Keep database software updated

### Naming Conventions
- Use lowercase with underscores: `employee_id`, `first_name`
- Table names should be plural or singular consistently
- Use descriptive names
- Prefix indexes: `idx_column_name`
- Prefix foreign keys: `fk_table_column`

### Data Integrity
1. Always define PRIMARY KEYS
2. Use FOREIGN KEYS to maintain referential integrity
3. Use NOT NULL for required fields
4. Use CHECK constraints for data validation
5. Use transactions for related operations

### Code Organization
```sql
-- Good: Readable and formatted
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 75000
ORDER BY e.last_name;

-- Bad: Hard to read
SELECT e.first_name,e.last_name,d.department_name,e.salary FROM employees e INNER JOIN departments d ON e.department_id=d.department_id WHERE e.salary>75000 ORDER BY e.last_name;
```

### Performance Tips
1. Analyze query execution plans using EXPLAIN
2. Monitor slow queries
3. Normalize database design (to a point)
4. Denormalize when necessary for read-heavy applications
5. Use connection pooling
6. Cache frequently accessed data
7. Partition large tables

---

## Practice Exercises

### Exercise 1: Basic Queries
Create a database for a library system with books, authors, and borrowers. Write queries to:
1. List all books published after 2020
2. Find the most borrowed book
3. List authors with more than 5 books

### Exercise 2: Joins
Create tables for a store with customers, orders, and products. Write queries to:
1. Find all orders with customer details
2. List products never ordered
3. Calculate total revenue by product category

### Exercise 3: Aggregations
Using an employee database:
1. Find the department with the highest average salary
2. Count employees hired each year
3. List the top 5 highest-paid employees per department

### Exercise 4: Advanced
1. Create a view showing order summaries
2. Write a stored procedure to update product prices
3. Use a CTE to find hierarchical manager relationships

---

## Conclusion

This tutorial covered the fundamentals of databases and SQL, from basic queries to advanced topics. Remember that practice is key to mastering SQL. Start with simple queries and gradually work your way up to complex operations.

### Next Steps
1. Practice with real datasets
2. Learn about database design and normalization
3. Explore stored procedures and triggers
4. Study query optimization techniques
5. Learn about specific DBMS features (PostgreSQL, MySQL, etc.)

### Additional Resources
- Official database documentation (MySQL, PostgreSQL, SQL Server)
- Online SQL practice platforms
- Database design books and courses
- SQL query optimization guides

Happy querying!
