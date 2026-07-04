{{ config(
    severity='warn',
)}}

select
1
from 
{{ source('STAGING','BOOKINGS')}}
where booking_amount < 200