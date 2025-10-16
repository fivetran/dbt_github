with issue_joined as (
    select *
    from {{ ref('int_github__issue_joined') }}  
)

select
  source_relation,
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
  {% if var('github__using_repo_team', true) %}
  repository_team_names,
  {% endif %}
  assignees,
  creator_login_name,
  creator_name,
  creator_company
from issue_joined
where not is_pull_request