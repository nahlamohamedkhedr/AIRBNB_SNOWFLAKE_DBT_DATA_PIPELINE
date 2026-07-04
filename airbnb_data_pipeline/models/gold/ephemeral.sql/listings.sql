{{ 
    config(materialized='ephemeral') 
    }}

with listings as (
    SELECT 
        listing_id,
        property_type,
        room_type,
        city,
    country,
    price_category,
    listing_created_at
FROM {{ ref('obt') }}
)
select * from listings 

