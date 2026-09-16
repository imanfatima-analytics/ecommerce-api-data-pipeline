import requests
import psycopg2
import os
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()


# -------------------------
# 1. Get data from API
# -------------------------

try:

    url = "https://fakestoreapi.com/products"

    response = requests.get(url)

    print("API Status:", response.status_code)

    products = response.json()


    # -------------------------
    # 2. Clean API data
    # -------------------------

    clean_products = []

    for product in products:

        clean_product = {
            "product_id": product["id"],
            "title": product["title"],
            "price": product["price"],
            "category": product["category"],
            "rating": product["rating"]["rate"],
            "rating_count": product["rating"]["count"]
        }

        clean_products.append(clean_product)


    # -------------------------
    # 3. Connect PostgreSQL
    # -------------------------

    connection = psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD")
    )

    cursor = connection.cursor()

    print("Database connected successfully!")


    # -------------------------
    # 4. Insert products
    # -------------------------

    query = """
    INSERT INTO products
    (product_id, title, price, category, rating, rating_count)
    VALUES (%s, %s, %s, %s, %s, %s)
    ON CONFLICT (product_id) DO NOTHING
    """

    for product in clean_products:

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


    # -------------------------
    # 5. Save changes
    # -------------------------

    connection.commit()

    print("All products inserted successfully!")


# -------------------------
# 6. Error Handling
# -------------------------

except Exception as e:

    print("Error occurred:", e)

    if "connection" in locals():
        connection.rollback()


# -------------------------
# 7. Close connection
# -------------------------

finally:

    if "cursor" in locals():
        cursor.close()

    if "connection" in locals():
        connection.close()

    print("Database connection closed.")