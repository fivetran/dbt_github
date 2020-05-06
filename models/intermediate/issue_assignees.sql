with issue_assignee as (

    select *
    from {{ ref('stg_github_issue_assignee') }}
  
), user as (

    select *
    from {{ ref('stg_github_user')}}

)

select
  issue_id,
  string_agg(login, ', ') as assignees
from issue_assignee
left join user on issue_assignee.user_id = user.user_id
group by 1
