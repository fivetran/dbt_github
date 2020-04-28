with issue as (

    select *
    from {{ source('github', 'issue') }}

), fields as (

    select 
      id as issue_id,
      body,
      closed_at,
      created_at,
      locked,
      milestone_id,
      number,
      pull_request,
      repository_id,
      state,
      title,
      updated_at,
      user_id
    from issue
)

select *
from fields