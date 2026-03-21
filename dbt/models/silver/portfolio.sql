-- enrich portfolio positions with latest available price
with portfolio as (
    select *
    from {{ source('raw', 'portfolio') }}
),

latest_prices as (
    select distinct on (asset)
        asset,
        price,
        currency,
        price_date
    from {{ ref('prices') }}
    order by asset, price_date desc
)

select
    p.asset,
    p.asset_type,
    p.quantity,
    p.buy_price,
    p.buy_currency,
    p.buy_date,
    lp.price                                        as current_price,
    lp.currency                                     as current_currency,
    lp.price_date                                   as price_last_updated,
    p.notes
from portfolio p
left join latest_prices lp
    on p.asset = lp.asset
    or (p.asset = 'USD' and lp.asset = 'ARS_OFICIAL')