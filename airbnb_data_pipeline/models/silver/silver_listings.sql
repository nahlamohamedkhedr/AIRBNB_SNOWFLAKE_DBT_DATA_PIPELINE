
{{ config(
    materialized='incremental',
    unique_key='listing_id'
) }}

SELECT
    listing_id,
    host_id,
    PROPERTY_TYPE,
    room_type,
    CITY,
    COUNTRY,
    ACCOMMODATES,
    BEDROOMS,
    BATHROOMS,
    PRICE_PER_NIGHT,
    {{ classify_column('PRICE_PER_NIGHT') }} AS PRICE_CATEGORY ,
    CREATED_AT
    from {{ ref('bronze_listings') }}