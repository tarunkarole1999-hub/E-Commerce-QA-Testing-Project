-- E-Commerce QA SQL Project
-- Database validation and QA test queries
-- Author: QA Tester
-- Purpose: Demonstrate SQL skills for manual QA / database testing

CREATE DATABASE IF NOT EXISTS ecommerce_qa;
USE ecommerce_qa;

-- =========================================================
-- 1. TABLES
-- =========================================================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS test_users;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE test_users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =========================================================
-- 2. SAMPLE DATA
-- =========================================================

INSERT INTO users (user_id, name, email) VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com'),
(2, 'Priya Singh', 'priya@gmail.com'),
(3, 'Amit Verma', 'amit@gmail.com');

INSERT INTO test_users (user_id, name, email) VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com'),
(2, 'Priya Singh', 'priya@gmail.com'),
(3, 'Amit Verma', 'amit@gmail.com');

INSERT INTO products (product_id, product_name, category, price) VALUES
(101, 'Laptop', 'Electronics', 50000.00),
(102, 'Mobile Phone', 'Electronics', 25000.00),
(103, 'Headphones', 'Accessories', 2500.00),
(104, 'Keyboard', 'Accessories', 1500.00);

INSERT INTO orders (order_id, user_id, total_amount, status) VALUES
(1, 1, 51800.00, 'Delivered'),
(2, 2, 8500.00, 'Pending'),
(3, 2, 12000.00, 'Shipped');

-- =========================================================
-- 3. BASIC SQL VALIDATION
-- =========================================================

-- View all users
SELECT * FROM users;

-- View all products
SELECT * FROM products;

-- View all orders
SELECT * FROM orders;

-- Find a specific user
SELECT *
FROM users
WHERE email = 'rahul@gmail.com';

-- Validate Laptop price
SELECT product_name, price
FROM products
WHERE product_name = 'Laptop';

-- =========================================================
-- 4. FILTERING / SORTING
-- =========================================================

SELECT *
FROM products
WHERE price > 10000;

SELECT *
FROM products
ORDER BY price DESC;

-- =========================================================
-- 5. AGGREGATE FUNCTIONS
-- =========================================================

SELECT COUNT(*) AS total_products
FROM products;

SELECT AVG(price) AS average_product_price
FROM products;

SELECT MAX(price) AS maximum_price
FROM products;

SELECT MIN(price) AS minimum_price
FROM products;

SELECT SUM(total_amount) AS total_order_value
FROM orders;

-- =========================================================
-- 6. GROUP BY / HAVING
-- =========================================================

SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status;

SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
HAVING COUNT(*) >= 1;

-- =========================================================
-- 7. INNER JOIN
-- =========================================================

SELECT
    users.name,
    orders.order_id,
    orders.total_amount,
    orders.status
FROM users
INNER JOIN orders
    ON users.user_id = orders.user_id;

-- Rahul Sharma's orders
SELECT
    users.name,
    orders.order_id,
    orders.total_amount,
    orders.status
FROM users
INNER JOIN orders
    ON users.user_id = orders.user_id
WHERE users.name = 'Rahul Sharma';

-- =========================================================
-- 8. LEFT JOIN / DATA INTEGRITY
-- =========================================================

-- Find orders whose user does not exist.
-- Expected result: 0 rows.
SELECT orders.*
FROM orders
LEFT JOIN users
    ON orders.user_id = users.user_id
WHERE users.user_id IS NULL;

-- =========================================================
-- 9. NULL VALIDATION
-- =========================================================

-- Product category must not be NULL.
-- Expected result: 0 rows.
SELECT *
FROM products
WHERE category IS NULL;

-- Order amount must not be NULL.
-- Expected result: 0 rows.
SELECT *
FROM orders
WHERE total_amount IS NULL;

-- =========================================================
-- 10. BUSINESS RULE VALIDATIONS
-- =========================================================

-- Product price must be greater than zero.
-- Expected result: 0 rows.
SELECT *
FROM products
WHERE price <= 0;

-- Order amount must be greater than zero.
-- Expected result: 0 rows.
SELECT *
FROM orders
WHERE total_amount <= 0;

-- Order status must be valid.
-- Expected result: 0 rows.
SELECT *
FROM orders
WHERE status NOT IN ('Pending', 'Shipped', 'Delivered');

-- High-value orders above ₹10,000
SELECT
    users.name,
    orders.order_id,
    orders.total_amount
FROM users
INNER JOIN orders
    ON users.user_id = orders.user_id
WHERE orders.total_amount > 10000
ORDER BY orders.total_amount DESC;

-- =========================================================
-- 11. DUPLICATE EMAIL VALIDATION
-- =========================================================

-- Expected result: 0 rows.
SELECT email, COUNT(*) AS email_count
FROM test_users
GROUP BY email
HAVING COUNT(*) > 1;

-- =========================================================
-- 12. QA TEST CASE SUMMARY
-- =========================================================

-- TC_SQL_01: User email validation
-- Expected: Rahul Sharma record returned
SELECT *
FROM users
WHERE email = 'rahul@gmail.com';

-- TC_SQL_02: Product price validation
-- Expected: Laptop price = 50000
SELECT product_name, price
FROM products
WHERE product_name = 'Laptop';

-- TC_SQL_03: User-order relationship
-- Expected: Rahul Sharma order is correctly linked
SELECT users.name, orders.order_id, orders.total_amount, orders.status
FROM users
INNER JOIN orders
    ON users.user_id = orders.user_id
WHERE users.name = 'Rahul Sharma';

-- TC_SQL_04: Duplicate email validation
-- Expected: 0 rows
SELECT email, COUNT(*) AS email_count
FROM test_users
GROUP BY email
HAVING COUNT(*) > 1;

-- TC_SQL_05: Invalid foreign key validation
-- Expected: 0 rows
SELECT orders.*
FROM orders
LEFT JOIN users
    ON orders.user_id = users.user_id
WHERE users.user_id IS NULL;

-- TC_SQL_06: Product category validation
-- Expected: 0 rows
SELECT *
FROM products
WHERE category IS NULL;

-- TC_SQL_07: Order status validation
-- Expected: 0 rows
SELECT *
FROM orders
WHERE status NOT IN ('Pending', 'Shipped', 'Delivered');

-- TC_SQL_08: High-value order validation
-- Expected: Rahul Sharma ₹51,800 and Priya Singh ₹12,000
SELECT users.name, orders.order_id, orders.total_amount
FROM users
INNER JOIN orders
    ON users.user_id = orders.user_id
WHERE orders.total_amount > 10000
ORDER BY orders.total_amount DESC;

-- TC_SQL_09: Invalid product price validation
-- Expected: 0 rows
SELECT *
FROM products
WHERE price <= 0;

-- TC_SQL_10: Invalid order amount validation
-- Expected: 0 rows
SELECT *
FROM orders
WHERE total_amount IS NULL
   OR total_amount <= 0;

-- =========================================================
-- PROJECT STATUS
-- =========================================================
-- SQL QA Practical Test Cases: 10/10 PASS
-- Topics demonstrated:
-- SELECT, WHERE, ORDER BY, COUNT, AVG, MAX, MIN, SUM,
-- GROUP BY, HAVING, INNER JOIN, LEFT JOIN, NULL validation,
-- UNIQUE constraint, PRIMARY KEY, FOREIGN KEY and QA validation.
