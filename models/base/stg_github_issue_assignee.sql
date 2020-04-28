with issue_assignee as (

    select *
    from {{ source('github', 'issue_assignee') }}

), fields as (

    select 
      issue_id,
      user_id
    from issue_assignee
)

select *
from fields