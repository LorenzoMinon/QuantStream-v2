-- unify all price sources into a single table
with crypto as (
    select
        symbol                          as asset,
        'crypto'                        as asset_type,
        open_time                       as price_date,
        close                           as price,
        'USD'                           as currency,
        source
    from {{ source('raw', 'crypto_prices') }}
),

stocks_usa as (
    select
        symbol                          as asset,
        'stock_usa'                     as asset_type,
        date                            as price_date,
        close                           as price,
        'USD'                           as currency,
        source
    from {{ source('raw', 'stock_prices_usa') }}
),

exchange_rates as (
    select
        currency_to                     as asset,
        'fx'                            as asset_type,
        date                            as price_date,
        rate                            as price,
        'ARS'                           as currency,
        source
    from {{ source('raw', 'exchange_rates') }}
)

select * from crypto
union all
select * from stocks_usa
union all
select * from exchange_rates