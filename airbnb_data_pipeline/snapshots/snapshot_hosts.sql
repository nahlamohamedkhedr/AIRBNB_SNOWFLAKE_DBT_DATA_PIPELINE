{% snapshot snapshot_hosts %}

{{
    config(
        target_schema='snapshots',
        unique_key='host_id',
        strategy='check',
        check_cols=['is_superhost', 'response_rate_quality', 'host_name']
    )
}} 

select
    host_id,
    host_name,
    host_since,
    is_superhost,
    response_rate_quality,
    created_at as host_created_at
from {{ ref('silver_hosts') }}   

{% endsnapshot %}  