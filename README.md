# E-Commerce API Data Pipeline

An end-to-end data pipeline that retrieves product data from a REST API, processes the JSON response using Python, and stores the transformed data in PostgreSQL.

The project demonstrates API integration, data transformation, database operations, duplicate handling, transaction management, error handling, environment variables, and SQL validation.

## Project Workflow

```text
REST API → Python → JSON → Data Cleaning → PostgreSQL → SQL Validation
Project Overview

The pipeline collects e-commerce product data from the Fake Store API and transforms it into a structured PostgreSQL table.

The following fields are processed:

Product ID
Product title
Price
Category
Rating
Rating count
API Source

Fake Store API:

https://fakestoreapi.com/products

The API provides sample e-commerce product data in JSON format.

Technologies Used
Python
REST API
JSON
Requests
PostgreSQL
psycopg2
python-dotenv
SQL
Git & GitHub
Data Pipeline
1. Extract

Python sends a GET request to the REST API and receives product data in JSON format.

2. Transform

The JSON response is processed and the required fields are extracted, including nested rating information.

clean_product = {
    "product_id": product["id"],
    "title": product["title"],
    "price": product["price"],
    "category": product["category"],
    "rating": product["rating"]["rate"],
    "rating_count": product["rating"]["count"]
}
3. Load

The cleaned data is inserted into PostgreSQL using psycopg2.

Duplicate product IDs are handled using:

ON CONFLICT (product_id) DO NOTHING
4. Validate

SQL queries are used to verify the stored data and perform basic analysis.

Validation includes:

Total product records
Duplicate product IDs
Missing values
Invalid prices
Product categories
Product ratings
Highest-rated products
Most expensive products
Database

Database: API_Project

Table: products

Column	Data Type	Description
product_id	INTEGER	Primary key
title	TEXT	Product name
price	NUMERIC(10,2)	Product price
category	TEXT	Product category
rating	NUMERIC(3,1)	Product rating
rating_count	INTEGER	Number of ratings
Table Schema
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    price NUMERIC(10,2),
    category TEXT,
    rating NUMERIC(3,1),
    rating_count INTEGER
);
Project Structure
ecommerce-api-data-pipeline/
├── README.md
├── requirements.txt
├── .gitignore
├── src/
│   ├── main.py
│   └── database.py
└── sql/
    └── queries.sql
File Description
File	Purpose
README.md	Project documentation
requirements.txt	Python dependencies
.gitignore	Excludes sensitive/unnecessary files
src/main.py	Main API-to-database pipeline
src/database.py	Database-related operations
sql/queries.sql	Validation and analysis queries
.env	Local database configuration
Installation

Install the required dependencies:

py -m pip install -r requirements.txt

Required packages:

requests
psycopg2-binary
python-dotenv
Configuration

Create a .env file in the project root:

DB_HOST=localhost
DB_PORT=5432
DB_NAME=API_Project
DB_USER=postgres
DB_PASSWORD=YOUR_PASSWORD

Keep .env out of GitHub. Database credentials should never be committed to a public repository.

Run the Project

Navigate to the project directory:

cd Downloads\ecommerce-api-data-pipeline

Run the pipeline:

py src\main.py

The pipeline will:

Request data from the REST API
Receive the JSON response
Extract and transform product data
Connect to PostgreSQL
Insert the products
Handle duplicate records
Commit the transaction
Close the database connection
SQL Validation
Total Products
SELECT COUNT(*) AS total_products
FROM products;
Check Duplicate IDs
SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
Check Missing Titles
SELECT *
FROM products
WHERE title IS NULL;
Category Analysis
SELECT
    category,
    COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS average_price
FROM products
GROUP BY category
ORDER BY total_products DESC;
Highest-Rated Products
SELECT
    product_id,
    title,
    rating,
    rating_count
FROM products
ORDER BY rating DESC
LIMIT 5;
Most Expensive Products
SELECT
    product_id,
    title,
    price,
    category
FROM products
ORDER BY price DESC
LIMIT 5;
Error Handling

The pipeline uses try, except, and finally to handle errors and safely close database resources.

Database transactions are managed using:

connection.commit()

and:

connection.rollback()
Security

Environment variables are used to keep database credentials outside the Python source code.

The .gitignore file excludes:

.env
venv/
__pycache__/

No real credentials should be uploaded to GitHub.

Skills Demonstrated
REST API integration
HTTP requests
JSON processing
Python data transformation
PostgreSQL
SQL
Database transactions
Duplicate handling
Exception handling
Environment variables
Git & GitHub
Basic ETL pipeline development
Future Improvements
API timeout and retry handling
Logging
Automated tests
Data validation improvements
Database indexes
Docker
FastAPI CRUD endpoints
Authentication
API documentation
Cloud deployment
Author

Iman Fatima

Software Engineering | AI Automation | Data Analytics | Backend Development
