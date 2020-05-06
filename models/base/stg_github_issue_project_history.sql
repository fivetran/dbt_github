with issue_project_history as (

    select *
    from {{ source('github', 'issue_project_history') }}

), fields as (

    select 
      issue_id,
      project_id,
      column_name,
      removed,
      updated_at,
      card_id
    from issue_project_history
)

select *
from fields