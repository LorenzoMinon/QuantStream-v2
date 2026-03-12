CREATE TABLE IF NOT EXISTS raw.crypto_prices (
    id              SERIAL PRIMARY KEY,
    symbol          VARCHAR(20)     NOT NULL,
    open_time       TIMESTAMP       NOT NULL,
    open            NUMERIC(18, 8)  NOT NULL,
    high            NUMERIC(18, 8)  NOT NULL,
    low             NUMERIC(18, 8)  NOT NULL,
    close           NUMERIC(18, 8)  NOT NULL,
    volume          NUMERIC(28, 8)  NOT NULL,
    source          VARCHAR(20)     NOT NULL DEFAULT 'binance',
    inserted_at     TIMESTAMP       NOT NULL DEFAULT NOW(),
    UNIQUE(symbol, open_time)
);

CREATE TABLE IF NOT EXISTS raw.stock_prices_usa (
    id              SERIAL PRIMARY KEY,
    symbol          VARCHAR(20)     NOT NULL,
    date            DATE            NOT NULL,
    open            NUMERIC(18, 4)  NOT NULL,
    high            NUMERIC(18, 4)  NOT NULL,
    low             NUMERIC(18, 4)  NOT NULL,
    close           NUMERIC(18, 4)  NOT NULL,
    volume          BIGINT          NOT NULL,
    source          VARCHAR(20)     NOT NULL DEFAULT 'alphavantage',
    inserted_at     TIMESTAMP       NOT NULL DEFAULT NOW(),
    UNIQUE(symbol, date)
);

CREATE TABLE IF NOT EXISTS raw.exchange_rates (
    id              SERIAL PRIMARY KEY,
    date            DATE            NOT NULL,
    currency_from   VARCHAR(10)     NOT NULL,
    currency_to     VARCHAR(30)     NOT NULL,
    rate            NUMERIC(18, 4)  NOT NULL,
    source          VARCHAR(20)     NOT NULL DEFAULT 'bcra',
    inserted_at     TIMESTAMP       NOT NULL DEFAULT NOW(),
    UNIQUE(date, currency_from, currency_to)
);