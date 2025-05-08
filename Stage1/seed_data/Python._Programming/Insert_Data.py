import psycopg2
from faker import Faker
import random

fake = Faker()

# Establishes a connection to the PostgreSQL database
conn = psycopg2.connect(
    dbname="mydatabase",
    user="myuser",
    password="mypassword",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()


# טבלת סוכנים
def insert_agents(n=800):
    agent_ids = set()
    agents = []

    while len(agents) < n:
        agent_id = random.randint(100000000, 999999999)
        if agent_id in agent_ids:
            continue  # avoid duplicates
        agent_ids.add(agent_id)

        full_name = fake.name()
        agency = fake.company()
        phone = fake.phone_number()
        email = fake.email()

        agents.append((agent_id, full_name, agency, phone, email))

    insert_query = """
    INSERT INTO Agent (AgentID, AgentFullName, AgencyName, PhoneNumber, Email)
    VALUES (%s, %s, %s, %s, %s);
    """

    try:
        cursor.executemany(insert_query, agents)
        conn.commit()
        print(f"[✓] {n} agents inserted into the Agent table.")
        return agent_ids  # to be able to use them as Foreign Keys
    except Exception as e:
        conn.rollback()
        print("[✗] Insert error :", e)
        return set()


# טבלת הפקות

def insert_productions(n=800):
    production_ids = set()
    productions = []

    production_types = ['Movie', 'Series', 'Documentary', 'Short', 'Special']
    genres = ['Drama', 'Comedy', 'Action', 'Thriller', 'Romance', 'Sci-Fi',
              'Horror', 'Fantasy', 'Animation']

    while len(productions) < n:
        production_id = random.randint(20, 999)
        if production_id in production_ids:
            continue
        production_ids.add(production_id)

        title = fake.sentence(nb_words=3).rstrip('.')
        prod_type = random.choice(production_types)
        release_date = fake.date_between(start_date='-45y', end_date='today')
        genre = random.choice(genres)
        rating = round(random.uniform(1.0, 9.9), 1)

        productions.append(
            (production_id, title, prod_type, release_date, genre, rating))

    insert_query = """
    INSERT INTO Production (ProductionID, Title, ProductionType, ReleaseDate, Genre, ProductionRating)
    VALUES (%s, %s, %s, %s, %s, %s);
    """

    try:
        cursor.executemany(insert_query, productions)
        conn.commit()
        print(f"[✓] {n} productions inserted in the Production table.")
        return production_ids # to be able to use them as Foreign Keys
    except Exception as e:
        conn.rollback()
        print("[✗] Insert error :", e)
        return set()


# טבלת יוצרים
def insert_content_creators(n=800, existing_agent_ids=None):
    if not existing_agent_ids:
        print("[✗] No agent available to link creators. ERROR")
        return

    creator_ids = set()
    creators = []
    agent_id_list = list(existing_agent_ids)

    countries = [fake.country() for _ in range(100)]

    while len(creators) < n:
        creator_id = random.randint(100000000, 999999999)
        if creator_id in creator_ids:
            continue
        creator_ids.add(creator_id)

        name = fake.name()
        birth_date = fake.date_of_birth(minimum_age=18, maximum_age=75)
        country = random.choice(countries)
        is_active = random.choice([True, False])

        join_date = fake.date_between(
            start_date=birth_date.replace(year=birth_date.year + 18),
            end_date="today")

        agent_id = random.choice(agent_id_list)

        creators.append((creator_id, name, birth_date, country, is_active,
                         join_date, agent_id))

    insert_query = """
    INSERT INTO Content_Creator (CreatorID, Content_CreatorFullName, BirthDate, Country, IsActive, JoinDate, AgentID)
    VALUES (%s, %s, %s, %s, %s, %s, %s);
    """

    try:
        cursor.executemany(insert_query, creators)
        conn.commit()
        print(f"[✓] {n} creators inserted into the Content_Creator table.")
        return creator_ids # to be able to use them as Foreign Keys
    except Exception as e:
        conn.rollback()
        print("[✗] Insert error :", e)
        return set()


# טבלת חוזים
def insert_contracts(n=800, existing_creator_ids=None,
                     existing_production_ids=None):
    if not existing_creator_ids or not existing_production_ids:
        print("[✗] Missing necessary IDs for foreign keys. ERROR")
        return

    contract_ids = set()
    contracts = []
    creator_list = list(existing_creator_ids)
    production_list = list(existing_production_ids)

    role_choices = [
        'Actor', 'Director', 'Writer', 'Producer', 'Editor',
        'Composer', 'Animator', 'Cinematographer', 'Consultant'
    ]

    while len(contracts) < n:
        contract_id = random.randint(300, 1200)
        if contract_id in contract_ids:
            continue
        contract_ids.add(contract_id)

        creator_id = random.choice(creator_list)
        production_id = random.choice(production_list)

        start_date = fake.date_between(start_date='-10y', end_date='today')
        end_date = fake.date_between(start_date=start_date,
                                     end_date=f"{start_date.year + 3}-12-31")

        payment = round(random.uniform(5000, 500000), 2)
        role = random.choice(role_choices)

        contracts.append((contract_id, creator_id, production_id, start_date,
                          end_date, payment, role))

    insert_query = """
    INSERT INTO Contract (ContractID, CreatorID, ProductionID, StartDate, EndDate, Payment, RoleContract)
    VALUES (%s, %s, %s, %s, %s, %s, %s);
    """

    try:
        cursor.executemany(insert_query, contracts)
        conn.commit()
        print(f"[✓] {n} contracts inserted into the Contract table.")
    except Exception as e:
        conn.rollback()
        print("[✗] Insert error :", e)


# טבלת פרסים
def insert_awards(n=800, existing_creator_ids=None):
    if not existing_creator_ids:
        print("[✗] No CreatorID available to insert rewards.")
        return

    award_ids = set()
    awards = []

    creator_id_list = list(existing_creator_ids)
    award_names = [
        "Best Director", "Best Script", "Rising Star", "Lifetime Achievement",
        "Best Cinematography", "Audience Choice", "Critics' Award",
        "Innovation in Film", "Best International Creator"
    ]

    while len(awards) < n:
        award_id = random.randint(1, 900)
        if award_id in award_ids:
            continue
        award_ids.add(award_id)

        creator_id = random.choice(creator_id_list)
        name = random.choice(award_names)
        year = fake.date_between(start_date='2000-01-01', end_date='today')

        awards.append((award_id, creator_id, name, year))

    insert_query = """
    INSERT INTO Award (AwardID, CreatorID, AwardName, AwardYear)
    VALUES (%s, %s, %s, %s);
    """

    try:
        cursor.executemany(insert_query, awards)
        conn.commit()
        print(f"[✓] {n} prices inserted in the Award table.")
    except Exception as e:
        conn.rollback()
        print("[✗] Insert error :", e)


# טבלת משוב
def insert_feedbacks(n=800, existing_production_ids=None):
    if not existing_production_ids:
        print("[✗] No ProductionID available to insert feedback..")
        return

    feedback_ids = set()
    feedbacks = []
    production_id_list = list(existing_production_ids)

    while len(feedbacks) < n:
        feedback_id = random.randint(1000, 2000)
        if feedback_id in feedback_ids:
            continue
        feedback_ids.add(feedback_id)

        production_id = random.choice(production_id_list)
        feedback_date = fake.date_between(start_date='2010-01-01',
                                          end_date='today')
        rating = round(random.uniform(1.0, 10.0), 1)
        comment = fake.text(max_nb_chars=200)

        feedbacks.append(
            (feedback_id, production_id, feedback_date, rating, comment))

    insert_query = """
    INSERT INTO Feedback (FeedbackID, ProductionID, FeedbackDate, FeedbackRating, FeedbackComment)
    VALUES (%s, %s, %s, %s, %s);
    """

    try:
        cursor.executemany(insert_query, feedbacks)
        conn.commit()
        print(f"[✓] {n} feedbacks inserted into the Feedback table.")
    except Exception as e:
        conn.rollback()
        print("[✗] Insert error :", e)


# Call each data insertion function in the correct order to create the database
# The order respects foreign key dependencies

agent_ids = insert_agents()
production_ids = insert_productions()
creators_ids = insert_content_creators(existing_agent_ids=agent_ids)
insert_contracts(existing_creator_ids=creators_ids,
                 existing_production_ids=production_ids)
insert_awards(existing_creator_ids=creators_ids)
insert_feedbacks(existing_production_ids=production_ids)
