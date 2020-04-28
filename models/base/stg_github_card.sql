with card as (

    select *
    from {{ source('github', 'card') }}

), fields as (

    select 
      id,
      archived,
      upated_at,
      is_deleted
    from card
)

select *
from fields