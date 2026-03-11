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