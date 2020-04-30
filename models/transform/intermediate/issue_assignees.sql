with issue_label as (

    select *
    from {{ ref('stg_github_issue_assignee') }}
  
), user as (

    select *
    from {{ ref('stg_github_user')}}

)

select
  issue_id,
  string_agg(login, ', ') as assignees
from github.issue_assignee
left join github.user on issue_assignee.user_id = user.id
group by 1
