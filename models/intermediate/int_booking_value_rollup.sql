with bookings as (

    select * from {{ ref('stg_bookings') }}

),

extras as (

    select * from {{ ref('int_booking_extras') }}

),

extra_rollup as (

    select
        booking_id,

        sum(extra_amount_aud) as total_extras_amount_aud,
        count(*) as extra_item_count,

        max(case when upper(extra_type) = 'BUNDLE' then 1 else 0 end) as has_bundle,
        max(case when upper(extra_type) = 'BAG' then 1 else 0 end) as has_bag,
        max(case when upper(extra_type) = 'SEAT' then 1 else 0 end) as has_seat,
        max(case when upper(extra_type) = 'MEAL' then 1 else 0 end) as has_meal

    from extras
    group by booking_id

),

final as (

    select
        b.booking_id,
        b.member_id,
        b.flight_date,
        b.route_type,
        b.fare_type,
        b.base_fare_aud,

        coalesce(er.total_extras_amount_aud, 0) as total_extras_amount_aud,
        coalesce(er.extra_item_count, 0) as extra_item_count,
        coalesce(er.has_bundle, 0) as has_bundle,
        coalesce(er.has_bag, 0) as has_bag,
        coalesce(er.has_seat, 0) as has_seat,
        coalesce(er.has_meal, 0) as has_meal,

        b.base_fare_aud + coalesce(er.total_extras_amount_aud, 0) as total_booking_value_aud

    from bookings b
    left join extra_rollup er
        on b.booking_id = er.booking_id

)

select *
from final