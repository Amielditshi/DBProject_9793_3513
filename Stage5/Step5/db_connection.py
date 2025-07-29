import psycopg2


def connect_to_db():
    try:
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            dbname="lastdb",
            user="dan",
            password="rebeccawife"
        )
        return conn
    except psycopg2.Error as e:
        print("Database connection error :", e)
        return None
