

SELECT * FROM {{ source('STAGING', 'HOSTS') }}             
{% if is_incremental() %}
WHERE CREATED_AT > (
    SELECT COALESCE(MAX(CREATED_AT), '1970-01-01'::timestamp)
    FROM {{ this }}
)
{% endif %} 