from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import psycopg2


def fetch_and_insert_exchange_rates():
    # dolarapi.com - all exchange rate types for ARS
    url = "https://dolarapi.com/v1/dolares"
    data = requests.get(url).json()

    conn = psycopg2.connect(
        host="quantstream_postgres",
        port=5432,
        dbname="airflow",
        user="airflow",
        password="airflow"
    )
    cursor = conn.cursor()

    today = datetime.utcnow().date()
    inserted = 0

    for item in data:
        cursor.execute("""
            INSERT INTO raw.exchange_rates
                (date, currency_from, currency_to, rate, source)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (date, currency_from, currency_to) DO UPDATE
                SET rate = EXCLUDED.rate
        """, (
            today,
            "USD",
            f"ARS_{item['casa'].upper()}",  # ARS_OFICIAL, ARS_BLUE, etc
            item["venta"],
            "dolarapi"
        ))
        inserted += 1

    conn.commit()
    cursor.close()
    conn.close()
    print(f"inserted/updated {inserted} exchange rates for {today}")


default_args = {
    "owner": "lorenzo",
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

with DAG(
    dag_id="bcra_exchange_rate_ingestion",
    default_args=default_args,
    start_date=datetime(2025, 1, 1),
    schedule_interval="0 */4 * * *",  # every 4 hours
    catchup=False
) as dag:

    ingest = PythonOperator(
        task_id="fetch_and_insert_exchange_rates",
        python_callable=fetch_and_insert_exchange_rates
    )