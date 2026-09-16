-- =========================================================
-- E-COMMERCE API DATA PIPELINE
-- SQL VALIDATION & ANALYSIS QUERIES
-- =========================================================


-- =========================================================
-- 1. View all products
-- =========================================================

SELECT *
FROM products
ORDER BY product_id;


-- =========================================================
-- 2. Count total products
-- =========================================================

SELECT COUNT(*) AS total_products
FROM products;


-- =========================================================
-- 3. Check for duplicate product IDs
-- =========================================================

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 4. Check for missing product titles
-- =========================================================

SELECT *
FROM products
WHERE title IS NULL;


-- =========================================================
-- 5. Check for missing categories
-- =========================================================

SELECT *
FROM products
WHERE category IS NULL;


-- =========================================================
-- 6. Check for invalid prices
-- =========================================================

SELECT *
FROM products
WHERE price < 0;


-- =========================================================
-- 7. Check product rating range
-- =========================================================

SELECT *
FROM products
WHERE rating < 0
   OR rating > 5;


-- =========================================================
-- 8. Check rating count
-- =========================================================

SELECT *
FROM products
WHERE rating_count < 0;


-- =========================================================
-- 9. Category summary
-- =========================================================

SELECT
    category,
    COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS average_price
FROM products
GROUP BY category
ORDER BY total_products DESC;


-- =========================================================
-- 10. Most expensive products
-- =========================================================

SELECT
    product_id,
    title,
    price,
    category
FROM products
ORDER BY price DESC
LIMIT 5;


-- =========================================================
-- 11. Cheapest products
-- =========================================================

SELECT
    product_id,
    title,
    price,
    category
FROM products
ORDER BY price ASC
LIMIT 5;


-- =========================================================
-- 12. Highest-rated products
-- =========================================================

SELECT
    product_id,
    title,
    rating,
    rating_count
FROM products
ORDER BY rating DESC
LIMIT 5;


-- =========================================================
-- 13. Products with the highest number of ratings
-- =========================================================

SELECT
    product_id,
    title,
    rating,
    rating_count
FROM products
ORDER BY rating_count DESC
LIMIT 5;


-- =========================================================
-- 14. Average product price
-- =========================================================

SELECT
    ROUND(AVG(price), 2) AS average_product_price
FROM products;


-- =========================================================
-- 15. Minimum and maximum price
-- =========================================================

SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM products;


-- =========================================================
-- 16. Average rating
-- =========================================================

SELECT
    ROUND(AVG(rating), 2) AS average_rating
FROM products;


-- =========================================================
-- 17. Products by category
-- =========================================================

SELECT
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;


-- =========================================================
-- 18. Category price analysis
-- =========================================================

SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(MIN(price), 2) AS minimum_price,
    ROUND(MAX(price), 2) AS maximum_price,
    ROUND(AVG(price), 2) AS average_price
FROM products
GROUP BY category
ORDER BY average_price DESC;


-- =========================================================
-- 19. High-rated products
-- =========================================================

SELECT
    product_id,
    title,
    category,
    price,
    rating
FROM products
WHERE rating >= 4
ORDER BY rating DESC;


-- =========================================================
-- 20. Final data quality check
-- =========================================================

SELECT
    COUNT(*) AS total_products,
    COUNT(title) AS products_with_title,
    COUNT(category) AS products_with_category,
    COUNT(price) AS products_with_price,
    COUNT(rating) AS products_with_rating
FROM products;