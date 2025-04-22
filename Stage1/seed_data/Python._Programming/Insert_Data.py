import psycopg2
from faker import Faker
import random

fake = Faker()
conn = psycopg2.connect(
    dbname="mydatabase",
    user="myuser",
    password="mypassword",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

# לרוקן טבלאות (אם יש נתונים קודמים)
#cursor.execute("TRUNCATE Feedback, Award, Contract, Production, Content_Creator, Agent RESTART IDENTITY CASCADE;")

num_records = 400

# טבלת סוכנים
for i in range(1, num_records + 1):
    cursor.execute(
        "INSERT INTO Agent VALUES (%s, %s, %s, %s, %s, %s)",
        (
            i,
            fake.name()[:100],
            fake.company()[:100],
            fake.phone_number()[:20],
            fake.email()[:100],
            fake.date()
        )
    )

# טבלת יוצרים
for i in range(1, num_records + 1):
    agent_id = random.randint(1, num_records)
    cursor.execute(
        "INSERT INTO Content_Creator VALUES (%s, %s, %s, %s, %s, %s, %s)",
        (
            i,
            fake.name()[:100],
            fake.date_of_birth(minimum_age=18, maximum_age=65),
            fake.country()[:50],
            random.choice([True, False]),
            fake.date(),
            agent_id
        )
    )

# טבלת הפקות
for i in range(1, num_records + 1):
    cursor.execute(
        "INSERT INTO Production VALUES (%s, %s, %s, %s, %s, %s)",
        (
            i,
            fake.sentence(nb_words=3)[:100],
            random.choice(['Movie', 'Series', 'Documentary'])[:50],
            fake.date_this_decade(),
            random.choice(['Drama', 'Comedy', 'Thriller', 'Action'])[:50],
            round(random.uniform(5.0, 10.0), 1)
        )
    )

# טבלת חוזים
for i in range(1, num_records + 1):
    creator_id = random.randint(1, num_records)
    production_id = random.randint(1, num_records)
    start = fake.date_between(start_date='-3y', end_date='-1y')
    end = fake.date_between(start_date=start, end_date='today')
    cursor.execute(
        "INSERT INTO Contract VALUES (%s, %s, %s, %s, %s, %s, %s)",
        (
            i,
            creator_id,
            production_id,
            start,
            end,
            float(random.randint(10000, 50000)),
            random.choice(['Actor', 'Director', 'Writer'])[:50]
        )
    )

# טבלת פרסים
for i in range(1, num_records + 1):
    cursor.execute(
        "INSERT INTO Award VALUES (%s, %s, %s, %s)",
        (
            i,
            random.choice(['Best Actor', 'Best Director', 'Best Script', "Viewer's Choice"])[:100],
            random.choice(['Performance', 'Directing', 'Writing', 'Audience'])[:50],
            fake.date_this_decade()
        )
    )

# טבלת משוב
for i in range(1, num_records + 1):
    production_id = random.randint(1, num_records)
    cursor.execute(
        "INSERT INTO Feedback VALUES (%s, %s, %s, %s, %s)",
        (
            i,
            production_id,
            fake.date_this_year(),
            round(random.uniform(5.0, 9.9), 1),  # ערך מוגבל ב־9.9
            fake.sentence(nb_words=6)
        )
    )


# שמירת שינויים וסגירה
conn.commit()
cursor.close()
conn.close()
