with source as (

    select * from {{ ref('raw_interactions') }}

),

renamed as (

    select
        trim(interaction_id)                           as interaction_id,
        cast(member_id as number)                      as member_id,
        cast(interaction_ts as timestamp_ntz)          as interaction_ts,
        upper(trim(channel))                           as channel,
        upper(trim(event_type))                        as event_type,
        upper(trim(search_destination))                as search_destination

    from source

)

select * from renamed   