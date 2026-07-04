{{ config(materialized='table') }}

select
    listing_id,
    property_type,
    room_type,
    city,
    country,
    price_category,
    listing_created_at
from {{ ref('snapshot_listings') }}
where dbt_valid_to is null -- current state only 