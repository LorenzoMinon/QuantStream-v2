# QuantStream v2

A personal financial data platform that ingests market data from multiple sources, transforms it through a medallion architecture, and serves it via interactive dashboards.

Built to practice and demonstrate data engineering skills: pipeline design, SQL modeling with dbt, orchestration with Airflow, and cloud infrastructure.

## Architecture
```
Binance API / Alpha Vantage API / dolarapi
                |
        Python ingestion (Airflow DAGs)
                |
        PostgreSQL - raw schema
                |
        dbt transformations
                |
        PostgreSQL - silver schema
                |
        Metabase dashboards
```

## Stack

- Orchestration: Apache Airflow
- Database: PostgreSQL
- Transformations: dbt
- Dashboards: Metabase
- Infrastructure: Docker Compose
- Cloud (WIP): AWS

## Data Sources

- Binance: BTCUSDT hourly prices
- Alpha Vantage: daily prices for AAPL, GOOGL, MSFT, SUPV, YPF
- dolarapi: USD/ARS exchange rates (oficial, blue, CCL, and others)
- Manual: personal portfolio positions via CSV

## Setup

Clone the repo and create a `.env` file in the root directory:
```
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=airflow
PGADMIN_EMAIL=your@email.com
PGADMIN_PASSWORD=yourpassword
AIRFLOW_UID=1000
ALPHAVANTAGE_KEY=your_api_key
```

Then run:
```bash
docker compose up -d
```

Initialize the database:
```bash
docker exec -i quantstream_postgres psql -U airflow -d airflow < ingestion/init_schemas.sql
docker exec -i quantstream_postgres psql -U airflow -d airflow < ingestion/init_tables.sql
```

Services:
- Airflow: http://localhost:8080
- pgAdmin: http://localhost:8081
- Metabase: http://localhost:3000

## Project Status

Currently in local development. Cloud migration to AWS in progress.