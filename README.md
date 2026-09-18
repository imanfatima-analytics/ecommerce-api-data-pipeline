# E-Commerce API Data Pipeline

An end-to-end Python data pipeline that retrieves product data from the Fake Store REST API, processes and cleans the JSON response, and stores the transformed data in PostgreSQL.

This project demonstrates practical experience with REST API integration, JSON processing, Python data transformation, PostgreSQL database operations, SQL validation, duplicate handling, transaction management, error handling, and environment-variable configuration.

## Project Overview

The purpose of this project is to build a complete API-to-database workflow using a real HTTP request and a relational database.

The pipeline takes product data from an external REST API and moves it through the following process:

REST API
↓
HTTP GET Request
↓
JSON Response
↓
Python Processing
↓
Data Cleaning & Transformation
↓
PostgreSQL
↓
SQL Validation & Analysis

The project processes the following product information:

* Product ID
* Product title
* Price
* Category
* Rating
* Rating count

## API Source

The project uses the Fake Store API as the external data source.

API endpoint:

https://fakestoreapi.com/products

The endpoint returns sample e-commerce product information in JSON format.

## Technologies Used

* Python
* REST API
* HTTP
* JSON
* Requests
* PostgreSQL
* psycopg2
* python-dotenv
* SQL
* Git
* GitHub

## How the Pipeline Works

### 1. Extract

Python sends an HTTP GET request to the API endpoint.

The response status is checked before processing the returned data.

```python
response = requests.get(url)

print("API Status:", response.status_code)

products = response.json()
```

The JSON response is then converted into Python data that can be processed by the application.

### 2. Transform

The API response contains the product information along with nested rating data.

The required fields are extracted and converted into a simpler structure before being stored in the database.

```python
clean_product = {
    "product_id": product["id"],
    "title": product["title"],
    "price": product["price"],
    "category": product["category"],
    "rating": product["rating"]["rate"],
    "rating_count": product["rating"]["count"]
}
```

This transformation separates the required database fields from the original API response structure.

### 3. Load

The transformed product records are inserted into PostgreSQL using `psycopg2`.

The database table uses `product_id` as the primary key.

Duplicate records are handled using:

```sql
ON CONFLICT (product_id) DO NOTHING
```

This allows the pipeline to skip an existing product instead of failing because of a duplicate primary key.

### 4. Validate

After loading the data, SQL queries are used to verify the database contents.

The validation process checks:

* Total number of products
* Duplicate product IDs
* Missing product titles
* Invalid prices
* Product categories
* Product ratings
* Highest-rated products
* Most expensive products
* Average prices by category

## Database Design

Database name:

`API_Project`

Table name:

`products`

| Column       | Data Type     | Description                  |
| ------------ | ------------- | ---------------------------- |
| product_id   | INTEGER       | Primary key for each product |
| title        | TEXT          | Product name                 |
| price        | NUMERIC(10,2) | Product price                |
| category     | TEXT          | Product category             |
| rating       | NUMERIC(3,1)  | Product rating               |
| rating_count | INTEGER       | Number of ratings            |

### Products Table

```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    price NUMERIC(10,2),
    category TEXT,
    rating NUMERIC(3,1),
    rating_count INTEGER
);
```

## Project Structure

```text
ecommerce-api-data-pipeline/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── src/
│   ├── main.py
│   └── database.py
│
└── sql/
    └── queries.sql
```

## File Responsibilities

### `src/main.py`

Contains the main pipeline workflow.

It handles:

* API request
* JSON response processing
* Product extraction
* Data transformation
* PostgreSQL connection
* Product insertion
* Duplicate handling
* Transaction handling
* Error handling
* Database connection cleanup

### `src/database.py`

Contains database-related functionality used by the project.

### `sql/queries.sql`

Contains SQL queries used to validate and analyze the product data stored in PostgreSQL.

### `requirements.txt`

Contains the Python packages required to run the project.

### `.gitignore`

Prevents sensitive and unnecessary files from being tracked by Git.

## Installation

Clone the repository:

```bash
git clone https://github.com/imanfatima-analytics/ecommerce-api-data-pipeline.git
```

Move into the project directory:

```bash
cd ecommerce-api-data-pipeline
```

Install the required dependencies:

```bash
py -m pip install -r requirements.txt
```

## Python Dependencies

The project uses the following packages:

```text
requests
psycopg2-binary
python-dotenv
```

### Requests

Used to send the HTTP request to the external REST API.

### psycopg2-binary

Used to connect Python with PostgreSQL and execute database operations.

### python-dotenv

Used to load database configuration from environment variables stored in the `.env` file.

## PostgreSQL Setup

Create the database:

```sql
CREATE DATABASE API_Project;
```

Connect to the database and create the products table:

```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    price NUMERIC(10,2),
    category TEXT,
    rating NUMERIC(3,1),
    rating_count INTEGER
);
```

## Environment Configuration

Database credentials are stored locally in a `.env` file instead of being written directly into the Python source code.

Example:

```text
DB_HOST=localhost
DB_PORT=5432
DB_NAME=API_Project
DB_USER=postgres
DB_PASSWORD=YOUR_PASSWORD
```

The application loads these values using `python-dotenv`.

```python
load_dotenv()
```

The database connection then reads the values through environment variables.

```python
os.getenv("DB_HOST")
os.getenv("DB_PORT")
os.getenv("DB_NAME")
os.getenv("DB_USER")
os.getenv("DB_PASSWORD")
```

The `.env` file is excluded from Git using `.gitignore`.

## Running the Pipeline

After PostgreSQL is configured and the environment variables are set, run:

```bash
py src\main.py
```

The application then:

1. Sends a request to the REST API
2. Receives the JSON response
3. Processes the product data
4. Extracts the required fields
5. Connects to PostgreSQL
6. Inserts the transformed records
7. Handles duplicate product IDs
8. Commits the transaction
9. Closes the database connection

A successful execution produces output similar to:

```text
API Status: 200
All products inserted successfully!
Database connection closed.
```

## Duplicate Handling

The `product_id` column is the primary key of the `products` table.

To prevent duplicate records from stopping the pipeline, the project uses:

```sql
ON CONFLICT (product_id) DO NOTHING
```

The behavior is:

Existing product ID
↓
Conflict detected
↓
Duplicate skipped
↓
Pipeline continues

This makes repeated pipeline execution safer because existing product records are not inserted again.

## Transaction Management

Database changes are committed after successful insertion:

```python
connection.commit()
```

If an error occurs during the database operation, the transaction can be rolled back:

```python
connection.rollback()
```

This prevents unsuccessful database operations from being treated as completed transactions.

## Error Handling

The pipeline uses Python exception handling:

```python
try:
    ...
except Exception as e:
    ...
finally:
    ...
```

This provides controlled handling of errors and ensures that database resources are closed after execution.

The `finally` block is used to close the cursor and database connection.

## SQL Validation

The project includes SQL queries for checking the quality and contents of the stored data.

### Total Products

```sql
SELECT COUNT(*) AS total_products
FROM products;
```

### View Products

```sql
SELECT *
FROM products
ORDER BY product_id;
```

### Check Duplicate IDs

```sql
SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
```

A correctly loaded dataset should return no duplicate product IDs.

### Check Missing Titles

```sql
SELECT *
FROM products
WHERE title IS NULL;
```

### Check Invalid Prices

```sql
SELECT *
FROM products
WHERE price < 0;
```

### Category Analysis

```sql
SELECT
    category,
    COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS average_price
FROM products
GROUP BY category
ORDER BY total_products DESC;
```

### Highest-Rated Products

```sql
SELECT
    product_id,
    title,
    rating,
    rating_count
FROM products
ORDER BY rating DESC
LIMIT 5;
```

### Most Expensive Products

```sql
SELECT
    product_id,
    title,
    price,
    category
FROM products
ORDER BY price DESC
LIMIT 5;
```

## Data Validation

The project performs basic validation after loading the data.

The validation process checks:

* Whether products were inserted
* Whether duplicate IDs exist
* Whether product titles are missing
* Whether prices contain invalid negative values
* Whether ratings are within the expected range
* Whether rating counts contain invalid values
* Product distribution by category

## Security

Database credentials are not hard-coded into the application.

The `.env` file is used for local configuration and is excluded from version control.

The `.gitignore` file contains entries such as:

```text
.env
venv/
__pycache__/
```

Sensitive database credentials should never be committed to a public GitHub repository.

## Git & GitHub

The project is maintained using Git and GitHub.

The repository demonstrates:

* Git repository management
* Meaningful commits
* Remote repository management
* Project structure
* `.gitignore`
* GitHub-based project documentation

Repository:

https://github.com/imanfatima-analytics/ecommerce-api-data-pipeline

## Key Learning Outcomes

This project provided practical experience with an end-to-end API-to-database workflow.

Key areas practiced include:

* REST API integration
* HTTP GET requests
* JSON processing
* Nested JSON extraction
* Python dictionaries and lists
* Data transformation
* PostgreSQL database design
* SQL table creation
* Primary keys
* Python-to-PostgreSQL connectivity
* Data insertion
* Duplicate handling
* Transactions
* Commit and rollback
* Exception handling
* Environment variables
* Credential protection
* SQL validation
* Git and GitHub

## Project Workflow Summary

```text
Fake Store REST API
        ↓
HTTP GET Request
        ↓
JSON Response
        ↓
Python
        ↓
Extract Required Fields
        ↓
Clean & Transform Data
        ↓
PostgreSQL
        ↓
Insert Products
        ↓
Handle Duplicates
        ↓
Commit Transaction
        ↓
SQL Validation
```

## Project Outcome

The completed pipeline successfully demonstrates how data can be collected from an external REST API, transformed with Python, stored in PostgreSQL, and validated using SQL.

It combines API integration, Python programming, relational database operations, and SQL into one practical project.

## Author

Iman Fatima

Software Engineering | AI Automation | Data Analytics | Backend Development

GitHub: https://github.com/imanfatima-analytics
