{{ config(materialized='ephemeral') }}


with hosts as (
SELECT 
    host_id,
    host_name,
    host_since,
    is_superhost,
    response_rate_quality,
    host_created_at 
FROM {{ ref('obt') }}
)

select * from hosts 