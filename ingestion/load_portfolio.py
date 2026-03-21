import pandas as pd
import psycopg2
from datetime import datetime

# load portfolio from csv
df = pd.read_csv("ingestion/portfolio.csv")

conn = psycopg2.connect(
    host="localhost",
    port=5432,
    dbname="airflow",
    user="airflow",
    password="airflow"
)
cursor = conn.cursor()

# truncate and reload — full refresh since portfolio changes manually
cursor.execute("TRUNCATE TABLE raw.portfolio")

for _, row in df.iterrows():
    cursor.execute("""
        INSERT INTO raw.portfolio
            (asset, asset_type, quantity, buy_price, buy_currency, buy_date, notes)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, (
        row["asset"],
        row["asset_type"],
        row["quantity"],
        row["buy_price"],
        row["buy_currency"],
        row["buy_date"],
        row["notes"]
    ))

conn.commit()
cursor.close()
conn.close()
print(f"loaded {len(df)} positions into raw.portfolio")