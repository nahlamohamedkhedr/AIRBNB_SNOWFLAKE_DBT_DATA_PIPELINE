

SELECT * FROM {{ source('STAGING', 'BOOKINGS') }} --select all from staging bookings table
{% if is_incremental() %} --if this is an incremental run, filter for records created after 
--the last created_at timestamp in the current table
WHERE 'CREATED_AT' > --check if the created_at timestamp is greater than the 
--max created_at timestamp in the current table
(SELECT COALESCE(MAX('CREATED_AT'), '1970-01-01') from {{ this  }}) --if there are no records 
--in the current table, use a default date of 1970-01-01 
{% endif %} 


