with issue_label_history as (

    select *
    from {{ source('github', 'issue_label_history') }}

), fields as (

    select 
      issue_id,
      updated_at,
      label,
      labeled
    from issue_label_history
)

select *
from fields