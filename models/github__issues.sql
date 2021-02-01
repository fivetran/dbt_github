with issue_joined as (
    select *
    from {{ ref('int_github__issue_joined') }}  
)

select
  issue_id,
  body,
  closed_at,
  created_at,
  is_locked,
  milestone_id,
  issue_number,
  is_pull_request,
  repository_id,
  state,
  title,
  updated_at,
  user_id,
  url_link,
  days_issue_open,
  number_of_times_reopened,
  labels,
  number_of_comments,
  repository,
  repository_team_names,
  assignees,
  creator_login_name,
  creator_name,
  creator_company
from issue_joined
where not is_pull_request