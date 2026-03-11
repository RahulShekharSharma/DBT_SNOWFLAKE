with source as (

    select * from {{ ref('raw_members') }}

),

renamed as (

    select
        cast(member_id as number)                as member_id,
        lower(trim(email))                       as email,
        cast(join_date as date)                  as join_date,
        trim(membership_tier)                    as membership_tier,
        cast(renewal_price_aud as number(10,2))  as renewal_price_aud,
        cast(qff_extra_flag as boolean)          as qff_extra_flag,
        cast(updated_at as timestamp_ntz)        as updated_at

    from source

)

select * from renamed