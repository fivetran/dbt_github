-- All staging models:
-- id fields should be casted as table_id (so, card_id in this example)
-- timestamp fields should be appended with _at
-- deleted fields, either _fivetran_deleted or is_deleted should be removed.

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