from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import psycopg2


def fetch_and_insert_crypto():
    # hit binance, grab last 48h of BTC candles
    url = "https://api.binance.com/api/v3/klines"
    params = {
        "symbol": "BTCUSDT",
        "interval": "1h",
        "limit": 48
    }
    candles = requests.get(url, params=params).json()

    # connect to postgres
    conn = psycopg2.connect(
        host="quantstream_postgres",
        port=5432,
        dbname="airflow",
        user="airflow",
        password="airflow"
    )
    cursor = conn.cursor()

    # insert, skip duplicates
    for candle in candles:
        open_time = datetime.fromtimestamp(candle[0] / 1000)
        cursor.execute("""
            INSERT INTO raw.crypto_prices 
                (symbol, open_time, open, high, low, close, volume, source)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (symbol, open_time) DO NOTHING
        """, (
            "BTCUSDT",
            open_time,
            candle[1],
            candle[2],
            candle[3],
            candle[4],
            candle[5],
            "binance"
        ))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"inserted {len(candles)} candles for BTCUSDT")


default_args = {
    "owner": "lorenzo",
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

with DAG(
    dag_id="binance_crypto_ingestion",
    default_args=default_args,
    start_date=datetime(2025, 1, 1),
    schedule_interval="*/30 * * * *",
    catchup=False
) as dag:

    ingest = PythonOperator(
        task_id="fetch_and_insert_btcusdt",
        python_callable=fetch_and_insert_crypto
    )