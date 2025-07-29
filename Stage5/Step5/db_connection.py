import psycopg2
# ------------------------------------------------------------
# Function: connect_to_db
# ------------------------------------------------------------
# This function establishes a connection to the PostgreSQL database
# using the provided host, port, database name, user, and password.
# If the connection is successful, it returns a connection object
# that can be used to interact with the database.
# In case of an error (e.g., wrong credentials or server not reachable),
# it prints an error message and returns None.
# ------------------------------------------------------------

def connect_to_db():
    try:
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            dbname="______",
            user="_______",
            password="______"
        )
        return conn
    except psycopg2.Error as e:
        print("Database connection error :", e)
        return None
