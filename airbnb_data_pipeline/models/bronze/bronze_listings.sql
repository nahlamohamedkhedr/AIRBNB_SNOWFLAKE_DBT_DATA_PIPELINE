



SELECT * FROM {{ source('STAGING', 'LISTINGS') }} 
{% if is_incremental() %}
WHERE 'CREATED_AT' > 
(SELECT COALESCE(MAX('CREATED_AT'), '1970-01-01') from {{ this  }})
{% endif %} 

 
