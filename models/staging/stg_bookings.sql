with source as (

    select * from {{ ref('raw_bookings') }}

),

renamed as (

    select
        trim(booking_id)                               as booking_id,
        cast(member_id as number)                      as member_id,
        cast(flight_date as date)                      as flight_date,
        upper(trim(route_type))                        as route_type,
        upper(trim(fare_type))                         as fare_type,
        cast(base_fare_aud as number(10,2))            as base_fare_aud,
        parse_json(flight_extras_json)                 as flight_extras,
        trim(booking_status)                           as booking_status,
        cast(updated_at as timestamp_ntz)              as updated_at

    from source

)

select * from renamed