from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import psycopg2
import time
from airflow.models import Variable

ALPHAVANTAGE_KEY = Variable.get("ALPHAVANTAGE_KEY")
SYMBOLS = ["AAPL", "GOOGL", "MSFT"]


def fetch_and_insert_stocks():
    conn = psycopg2.connect(
        host="quantstream_postgres",
        port=5432,
        dbname="airflow",
        user="airflow",
        password="airflow"
    )
    cursor = conn.cursor()

    for symbol in SYMBOLS:
        # daily adjusted prices, compact = last 100 days
        url = "https://www.alphavantage.co/query"
        params = {
            "function": "TIME_SERIES_DAILY",
            "symbol": symbol,
            "outputsize": "compact",
            "apikey": ALPHAVANTAGE_KEY
        }
        data = requests.get(url, params=params).json()
        series = data.get("Time Series (Daily)", {})

        if not series:
            print(f"no data for {symbol}, skipping")
            continue

        for date_str, values in series.items():
            cursor.execute("""
                INSERT INTO raw.stock_prices_usa
                    (symbol, date, open, high, low, close, volume, source)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (symbol, date) DO NOTHING
            """, (
                symbol,
                date_str,
                values["1. open"],
                values["2. high"],
                values["3. low"],
                values["4. close"],
                values["5. volume"],
                "alphavantage"
            ))

        conn.commit()
        print(f"inserted {len(series)} rows for {symbol}")
        time.sleep(15) # solution 1

    cursor.close()
    conn.close()


default_args = {
    "owner": "lorenzo",
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

with DAG(
    dag_id="alphavantage_stock_ingestion",
    default_args=default_args,
    start_date=datetime(2025, 1, 1),
    schedule_interval="0 22 * * 1-5",  # weekdays at 22:00 UTC (market close)
    catchup=False
) as dag:

    ingest = PythonOperator(
        task_id="fetch_and_insert_usa_stocks",
        python_callable=fetch_and_insert_stocks
    )