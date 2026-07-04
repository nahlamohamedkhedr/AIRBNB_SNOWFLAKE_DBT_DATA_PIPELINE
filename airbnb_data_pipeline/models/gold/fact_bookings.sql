{{ config(materialized='table') }}

select
    sb.booking_id,
    sb.listing_id,
    sl.host_id,

    coalesce(cast(sb.booking_date as date), '9999-12-31'::date) as date_id,

    sb.booking_status,

    sb.total_booking_amount,
    sb.service_fee,
    sb.cleaning_fee,

    sl.price_per_night,
    sl.accommodates,
    sl.bedrooms,
    sl.bathrooms,

    sh.response_rate

from {{ ref('silver_bookings') }} sb

left join {{ ref('silver_listings') }} sl
    on sb.listing_id = sl.listing_id

left join {{ ref('silver_hosts') }} sh
    on sl.host_id = sh.host_id 