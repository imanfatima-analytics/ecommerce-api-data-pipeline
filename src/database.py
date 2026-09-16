import psycopg2

connection = psycopg2.connect(
    host="localhost",
    port="5432",
    database="API_Project",
    user="postgres",
    password="pakistan1"
)

print("Database connected successfully!")


cursor = connection.cursor()

product = {
    "product_id": 1,
    "title": "Test Product",
    "price": 99.99,
    "category": "electronics",
    "rating": 4.5,
    "rating_count": 100
}

query = """
INSERT INTO products
(product_id, title, price, category, rating, rating_count)
VALUES (%s, %s, %s, %s, %s, %s)
"""

cursor.execute(
    query,
    (
        product["product_id"],
        product["title"],
        product["price"],
        product["category"],
        product["rating"],
        product["rating_count"]
    )
)

connection.commit()

print("Product inserted successfully!")

cursor.close()
connection.close()