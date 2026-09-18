# E-Commerce API Data Pipeline

## Project Overview

An end-to-end data pipeline that consumes product data from a REST API, processes and cleans the JSON data using Python, and stores the transformed data in PostgreSQL.

This project demonstrates practical API integration, data transformation, database operations, duplicate handling, transaction management, error handling, environment-variable security, and SQL validation.

---

## Project Architecture

External REST API
        ↓
      Python
        ↓
     JSON Data
        ↓
   Data Cleaning
        ↓
    PostgreSQL
        ↓
   SQL Validation
Business Problem

The goal of this project is to demonstrate how product data can be collected from an external REST API, transformed into a structured format, stored in a relational database, and validated using SQL.

The pipeline processes:

Product information
Product prices
Product categories
Product ratings
Rating counts
API Source

This project consumes product data from the Fake Store API:

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
Git
GitHub
Python Libraries
Requests

Used to send HTTP requests to the external REST API.

response = requests.get(url)
psycopg2

Used to connect Python with PostgreSQL.

connection = psycopg2.connect(...)
python-dotenv

Used to load database credentials from the .env file.

from dotenv import load_dotenv

load_dotenv()
Data Pipeline
1. Extract

Python sends a GET request to the external REST API.

REST API
   ↓
Python
2. Transform

The JSON response is processed and selected fields are extracted.

The project extracts:

product_id
title
price
category
rating
rating_count
3. Load

The cleaned data is inserted into PostgreSQL.

Python
   ↓
PostgreSQL
4. Validate

SQL queries are used to verify the stored data.

Validation includes:

Total records
Duplicate IDs
Missing values
Invalid prices
Product categories
Product ratings
Database
Database Name
API_Project
Table Name
products
Products Table Schema
Column	Data Type	Description
product_id	INTEGER	Primary key
title	TEXT	Product name
price	NUMERIC(10,2)	Product price
category	TEXT	Product category
rating	NUMERIC(3,1)	Product rating
rating_count	INTEGER	Number of ratings
Database Table Creation
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    price NUMERIC(10,2),
    category TEXT,
    rating NUMERIC(3,1),
    rating_count INTEGER
);
Data Cleaning

The API response contains nested JSON data.

For example, rating information is accessed using:

product["rating"]["rate"]

and:

product["rating"]["count"]

The project transforms the API response into a cleaner structure:

clean_product = {
    "product_id": product["id"],
    "title": product["title"],
    "price": product["price"],
    "category": product["category"],
    "rating": product["rating"]["rate"],
    "rating_count": product["rating"]["count"]
}
Duplicate Handling

The project uses:

ON CONFLICT (product_id) DO NOTHING

This prevents the pipeline from failing when a product with an existing product_id is encountered.

For example:

Product ID 1 already exists
        ↓
ON CONFLICT
        ↓
Skip duplicate
        ↓
Continue processing
Transaction Management

Database changes are saved using:

connection.commit()

If an error occurs, the transaction can be rolled back:

connection.rollback()
Transaction Flow
Database Operations
        ↓
     Success?
     /       \
   YES        NO
    ↓          ↓
 commit()   rollback()
Error Handling

The pipeline uses Python exception handling:

try:
    ...
except Exception as e:
    ...
finally:
    ...

This allows the application to:

Handle errors
Roll back failed database operations
Close database resources
Prevent uncontrolled application failure
Environment Variables

Database credentials are stored in .env instead of being hard-coded directly in Python.

Example:

DB_HOST=localhost
DB_PORT=5432
DB_NAME=API_Project
DB_USER=postgres
DB_PASSWORD=YOUR_PASSWORD

The Python application reads these values using:

os.getenv("DB_HOST")
os.getenv("DB_PORT")
os.getenv("DB_NAME")
os.getenv("DB_USER")
os.getenv("DB_PASSWORD")
Credential Security

The .env file contains sensitive database credentials.

Therefore, .env is excluded from Git using .gitignore.

.env
venv/
__pycache__/

The real database password should never be uploaded to GitHub.

Project Structure
git_restapi/
│
├── README.md
├── requirements.txt
├── .gitignore
├── .env
│
├── src/
│   ├── main.py
│   └── database.py
│
└── sql/
    └── queries.sql
File Responsibilities

README.md

Project documentation.

requirements.txt

Contains Python dependencies.

.gitignore

Prevents sensitive and unnecessary files from being tracked by Git.

.env

Stores local environment variables and database credentials.

src/main.py

Main API → Python → PostgreSQL pipeline.

src/database.py

Database-related Python code.

sql/queries.sql

SQL queries used for database validation and analysis.

Requirements

Install the required Python packages:

py -m pip install -r requirements.txt

The project uses:

requests
psycopg2-binary
python-dotenv
Database Setup

Create the PostgreSQL database:

CREATE DATABASE API_Project;

Then create the products table:

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    price NUMERIC(10,2),
    category TEXT,
    rating NUMERIC(3,1),
    rating_count INTEGER
);
Configuration

Create a .env file in the project root:

DB_HOST=localhost
DB_PORT=5432
DB_NAME=API_Project
DB_USER=postgres
DB_PASSWORD=YOUR_PASSWORD

Replace YOUR_PASSWORD with your local PostgreSQL password.

Do not upload the .env file to GitHub.

How to Run

Open CMD and navigate to the project:

cd Downloads\git_restapi

Run the main pipeline:

py src\main.py

The application performs the following operations:

1. Connect to REST API
2. Receive JSON data
3. Extract product information
4. Clean and transform the data
5. Connect to PostgreSQL
6. Insert products
7. Handle duplicate product IDs
8. Commit database changes
9. Handle errors
10. Close database connection
Expected Output

A successful run should produce output similar to:

API Status: 200
Database connected successfully!
All products inserted successfully!
Database connection closed.
SQL Validation
Check Total Products
SELECT COUNT(*) AS total_products
FROM products;
View All Products
SELECT *
FROM products
ORDER BY product_id;
Check Duplicate Product IDs
SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

Expected result:

No rows
Check Missing Product Titles
SELECT *
FROM products
WHERE title IS NULL;
Check Invalid Prices
SELECT *
FROM products
WHERE price < 0;
Product Category Analysis
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
Complete Data Flow
              EXTERNAL REST API
                      │
                      ▼
              HTTP GET REQUEST
                      │
                      ▼
                 JSON DATA
                      │
                      ▼
                  PYTHON
                      │
            ┌─────────┴─────────┐
            │                   │
         Extract             Transform
            │                   │
            └─────────┬─────────┘
                      ▼
                Clean Data
                      │
                      ▼
                PostgreSQL
                      │
                      ▼
                   INSERT
                      │
                      ▼
              Duplicate Handling
                      │
                      ▼
                  COMMIT
                      │
                      ▼
               SQL Validation
Key Concepts Practiced
REST API
API fundamentals
REST architecture
HTTP requests
GET method
Endpoints
JSON responses
Python
requests
JSON processing
Lists
Dictionaries
Loops
Data transformation
Exception handling
Environment variables
PostgreSQL
Database creation
Table creation
Primary keys
INSERT operations
Transactions
Commit
Rollback
SQL validation
Security
.env
Environment variables
.gitignore
Credential protection
Git & GitHub
Git repository
Commits
Branches
GitHub
Repository structure
Project documentation
Learning Outcome

This project demonstrates an end-to-end integration between an external REST API, Python, and PostgreSQL.

The complete workflow is:

API
 ↓
Python
 ↓
JSON
 ↓
Data Cleaning
 ↓
PostgreSQL
 ↓
SQL Validation
 ↓
GitHub

The project provides practical experience with API integration, Python data processing, relational databases, SQL, error handling, transaction management, and secure configuration.

Future Improvements

Possible improvements include:

Add logging
Add API timeout handling
Add more robust data validation
Add automated tests
Add database indexes
Add Docker
Add FastAPI
Create CRUD API endpoints
Add authentication
Add API documentation
Deploy the application to the cloud
Author

Iman Fatima

Software Engineering | AI Automation | Data Analytics | Backend Development

Skills Demonstrated

Python • REST API • JSON • PostgreSQL • SQL • Git • GitHub • Data Processing • ETL • API Integration


### Save it as

```text
README.md

Make sure Windows doesn't save it as:

README.md.txt

Your root folder should now be:

git_restapi
│
├── README.md          ✅
├── .env               🔒
├── .gitignore         ✅
├── requirements.txt   ✅
├── src/               ✅
└── sql/               ✅
