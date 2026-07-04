{% snapshot snapshot_listings %}

{{
    config(
        target_schema='snapshots',
        unique_key='listing_id',
        strategy='check',
        check_cols=['property_type', 'room_type', 'city', 'country', 'price_category']
    )
}}

select
    listing_id,
    property_type,
    room_type,
    city,
    country,
    price_category,
    created_at as listing_created_at
from {{ ref('silver_listings') }}   

{% endsnapshot %}