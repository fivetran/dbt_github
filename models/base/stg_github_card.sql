with card as (

    select *
    from {{ source('github', 'card') }}

), fields as (

    select 
      id,
      archived,
      updated_at,
      is_deleted
    from card
)

select *
from fields