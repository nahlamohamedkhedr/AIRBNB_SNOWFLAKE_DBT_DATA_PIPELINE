

{% set configs = [
{ 
    "table" : "AIRBNB_DB.silver.silver_bookings", 
    "columns" : "silver_bookings.*",
    "alias" : "silver_bookings"
},
{
    "table" : "AIRBNB_DB.silver.silver_listings",
    "columns" : 
           "silver_listings.host_id,
            silver_listings.PROPERTY_TYPE,
            silver_listings.ROOM_TYPE,
            silver_listings.CITY,
            silver_listings.COUNTRY,
            silver_listings.ACCOMMODATES,
            silver_listings.BEDROOMS,
            silver_listings.BATHROOMS,
            silver_listings.PRICE_PER_NIGHT,
            silver_listings.price_category,
            silver_listings.CREATED_AT as listing_created_at",
    "alias": "silver_listings",
    "join" : "silver_bookings.listing_id = silver_listings.listing_id"
},
{
    "table" : "AIRBNB_DB.silver.silver_hosts",
    "columns" : 
           "silver_hosts.host_name,
            silver_hosts.host_since,
            silver_hosts.is_superhost,
            silver_hosts.response_rate,
            silver_hosts.response_rate_quality,
            silver_hosts.created_at as host_created_at"
    ,
    "alias" : "silver_hosts",
    "join" : "silver_listings.host_id = silver_hosts.host_id"
}
]
%}




select
    {% for config in configs %}
        {{ config['columns'] }}{% if not loop.last %},{% endif %}
    {% endfor %} 

from

    {% for config in configs %}
        {% if loop.first %}
            {{ config['table'] }} as {{ config['alias'] }}
        {% else %}
            left join {{ config['table'] }} as {{ config['alias'] }}
            on {{ config['join'] }}
        {% endif %}
    {% endfor %}




