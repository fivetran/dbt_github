with issue as (
    select *
    from {{ ref('stg_github__issue') }}
), 

issue_labels as (
    select *
    from {{ ref('int_github__issue_labels')}}
), 

repository_teams as (
    select *
    from {{ ref('int_github__repository_teams')}}
), 

issue_assignees as (
    select *
    from {{ ref('int_github__issue_assignees')}}
), 

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
    from {{ ref('stg_github__user')}}
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
    from {{ ref('stg_github__pull_request')}}
)

select
  issue.*,
  {{ dbt_utils.concat(["'https://github.com/'",'repository_teams.repository',"'/pull/'", 'issue.issue_number']) }} as url_link,
  issue_open_length.days_issue_open,
  issue_open_length.number_of_times_reopened,
  labels.labels,
  issue_comments.number_of_comments,
  repository_teams.repository,
  repository_teams.repository_team_names,
  issue_assignees.assignees,
  creator.login_name as creator_login_name,
  creator.name as creator_name,
  creator.company as creator_company,
  hours_request_review_to_first_review,
  hours_request_review_to_first_action,
  hours_request_review_to_merge,
  merged_at,
  reviewers,
  number_of_reviews
from issue
left join issue_labels as labels
  on issue.issue_id = labels.issue_id
join repository_teams
  on issue.repository_id = repository_teams.repository_id
left join issue_assignees
  on issue.issue_id = issue_assignees.issue_id
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