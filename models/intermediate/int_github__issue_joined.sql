with issue as (
    select *
    from {{ ref('stg_github__issue') }}
), 

{%- if var('github__using_issue_label', True) and var('github__using_label', True) %}
issue_labels as (
    select *
    from {{ ref('int_github__issue_labels')}}
), 
{% endif -%}

repository_teams as (
    select 
    {% if var('github__using_repo_team', true) %}
      *
    from {{ ref('int_github__repository_teams') }}

    {% else %}
      repository_id,
      full_name as repository
    from {{ ref('stg_github__repository') }}

    {% endif %}
), 

{%- if var('github__using_issue_assignee', True) %}
issue_assignees as (
    select *
    from {{ ref('int_github__issue_assignees')}}
), 
{% endif -%}

issue_open_length as (
    select *
    from {{ ref('int_github__issue_open_length')}}
), 

issue_comments as (
    select *
    from {{ ref('int_github__issue_comments')}}
), 

creator as (
    select *
    from {{ ref('stg_github__user') }}
), 

pull_request_times as (
    select *
    from {{ ref('int_github__pull_request_times')}}
), 

pull_request_reviewers as (
    select *
    from {{ ref('int_github__pull_request_reviewers')}}
), 

pull_request as (
    select *
    from {{ ref('stg_github__pull_request') }}
)

select
  issue.*,
  case 
    when issue.is_pull_request then {{ dbt.concat(["'https://github.com/'",'repository_teams.repository',"'/pull/'", 'issue.issue_number']) }}
    else {{ dbt.concat(["'https://github.com/'",'repository_teams.repository',"'/issues/'", 'issue.issue_number']) }}
  end as url_link,
  issue_open_length.days_issue_open,
  issue_open_length.number_of_times_reopened,

  {%- if var('github__using_issue_label', True) and var('github__using_label', True) -%}
  labels.labels,
  {%- else %}
  cast(null as {{ dbt.type_string() }}) as labels,
  {% endif -%}

  issue_comments.number_of_comments,
  repository_teams.repository,

  {%- if var('github__using_repo_team', true) %}
  repository_teams.repository_team_names,
  {% endif -%}

  {%- if var('github__using_issue_assignee', True) -%}
  issue_assignees.assignees,
  {%- else -%}
  cast(null as {{ dbt.type_string() }}) as assignees,
  {% endif -%}

  creator.login_name as creator_login_name,
  creator.name as creator_name,
  creator.company as creator_company,

  {%- if var('github__using_requested_reviewer_history', True) -%}
  pull_request_times.hours_request_review_to_first_review,
  pull_request_times.hours_request_review_to_first_action,
  pull_request_times.hours_request_review_to_merge,
  {% endif %}

  pull_request_times.merged_at,
  pull_request_reviewers.reviewers, 
  {# requested_reviewers will be null if requested_reviewer_history is not used. See int_github__pull_request_reviewers #}
  pull_request_reviewers.requested_reviewers,
  pull_request_reviewers.number_of_reviews
  
from issue
{%- if var('github__using_issue_label', True) and var('github__using_label', True) %}
left join issue_labels as labels
  on issue.issue_id = labels.issue_id
{%- endif %}
join repository_teams
  on issue.repository_id = repository_teams.repository_id
{%- if var('github__using_issue_assignee', True) %}
left join issue_assignees
  on issue.issue_id = issue_assignees.issue_id
{%- endif %}
left join issue_open_length
  on issue.issue_id = issue_open_length.issue_id
left join issue_comments 
  on issue.issue_id = issue_comments.issue_id
left join creator 
  on issue.user_id = creator.user_id
left join pull_request
  on issue.issue_id = pull_request.issue_id
left join pull_request_times
  on issue.issue_id = pull_request_times.issue_id
left join pull_request_reviewers
  on pull_request.pull_request_id = pull_request_reviewers.pull_request_id
