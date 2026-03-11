with bookings as (

    select * from {{ ref('stg_bookings') }}

),

member_tier_history as (

    select
        member_id,
        tier_effective_from,
        membership_tier,
        qff_extra_flag,
        renewal_price_aud,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('snap_member_tier_history') }}

),

final as (

    select
        b.booking_id,
        b.member_id,
        b.flight_date,
        b.route_type,
        b.fare_type,
        b.base_fare_aud,
        b.booking_status,
        b.updated_at as booking_updated_at,

        m.membership_tier as membership_tier_at_booking,
        m.qff_extra_flag as qff_extra_flag_at_booking,
        m.renewal_price_aud as renewal_price_aud_at_booking,
        m.tier_effective_from as tier_effective_from,
        m.dbt_valid_from as snapshot_valid_from,
        m.dbt_valid_to as snapshot_valid_to

    from bookings b
    left join member_tier_history m
        on b.member_id = m.member_id
       and b.flight_date >= m.tier_effective_from
       and (
            m.dbt_valid_to is null
            or cast(b.flight_date as timestamp_ntz) < m.dbt_valid_to
       )

)

select *
from final