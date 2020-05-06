-- All staging models:
-- id fields should be casted as table_id (so, card_id in this example)
-- timestamp fields should be appended with _at
-- deleted fields, either _fivetran_deleted or is_deleted should be removed.

with card as (

    select *
    from {{ source('github', 'card') }}

), fields as (

    select 
      id as card_id,
      archived,
      updated_at
    from card
    where not is_deleted
)

select *
from fields