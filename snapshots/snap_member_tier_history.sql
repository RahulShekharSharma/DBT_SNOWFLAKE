{% snapshot snap_member_tier_history %}

{{
    config(
        unique_key='member_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    member_id,
    email,
    join_date,
    tier_effective_from,
    membership_tier,
    renewal_price_aud,
    qff_extra_flag,
    updated_at
from {{ ref('stg_members') }}

{% endsnapshot %}