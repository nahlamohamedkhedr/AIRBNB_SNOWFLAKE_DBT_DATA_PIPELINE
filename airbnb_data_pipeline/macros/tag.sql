{% macro classify_column(column_name) %}

    case
        when {{ column_name }} < 100 then 'Low'
        when {{ column_name }} >= 100 and {{ column_name }} < 500 then 'Medium'
        else 'High'
    end

{% endmacro %}