{{ config(materialized='table') }}

with date_spine as (
    select
        dateadd(day, seq4(), '2018-01-01'::date) as full_date
    from table(generator(rowcount => 3300))
),

filtered_dates as (                       -- ⚠️ WHERE بدل QUALIFY — QUALIFY بيتطلب window function
    select full_date
    from date_spine
    where full_date <= '2027-01-01'::date
),

real_dates as (
    select
        full_date::date                        as date_id,
        full_date                              as full_date,
        extract(year from full_date)            as year,
        extract(quarter from full_date)          as quarter,
        extract(month from full_date)            as month,
        trim(to_char(full_date, 'Month'))        as month_name,
        extract(day from full_date)              as day,
        extract(dayofweek from full_date)         as day_of_week,
        trim(to_char(full_date, 'Day'))           as day_name,
        case when extract(dayofweek from full_date) in (0, 6)
             then true else false end            as is_weekend
    from filtered_dates
),

unknown_row as (
    select
        '9999-12-31'::date as date_id,
        '9999-12-31'::date as full_date,
        9999               as year,
        null                as quarter,
        null                as month,
        'Unknown'           as month_name,
        null                as day,
        null                as day_of_week,
        'Unknown'           as day_name,
        false               as is_weekend
)

select * from real_dates
union all
select * from unknown_row 