{{ config(materialized='table') }}

select
    host_id,
    host_name,
    host_since,
    is_superhost,
    response_rate_quality,
    host_created_at,
    dbt_valid_from                                            as valid_from,
    coalesce(dbt_valid_to, '9999-12-31'::timestamp)           as valid_to,
    case when dbt_valid_to is null then true else false end   as is_current
from {{ ref('snapshot_hosts') }} 