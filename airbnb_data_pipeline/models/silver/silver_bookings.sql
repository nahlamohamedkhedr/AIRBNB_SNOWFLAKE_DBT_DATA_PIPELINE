

{{ config(
    materialized='incremental',
    unique_key='booking_id'
)
}}



select BOOKING_ID,
LISTING_ID,
BOOKING_DATE,
NIGHTS_BOOKED,
BOOKING_AMOUNT,
{{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2) }} AS TOTAL_BOOKING_AMOUNT,
CLEANING_FEE,
SERVICE_FEE,
BOOKING_STATUS,
CREATED_AT
from {{ ref('bronze_bookings') }} 