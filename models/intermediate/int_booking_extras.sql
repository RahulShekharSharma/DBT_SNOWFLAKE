with bookings as (

    select * from {{ ref('stg_bookings') }}

),

flattened as (

    select
        b.booking_id,
        b.member_id,
        b.flight_date,
        b.route_type,
        b.fare_type,
        b.base_fare_aud,
        b.booking_status,
        b.updated_at,

        f.value:extra_type::string          as extra_type,
        f.value:amount::number(10,2)        as extra_amount_aud

    from bookings b,
    lateral flatten(input => b.flight_extras) f

)

select *
from flattened