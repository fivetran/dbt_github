with issue as (

    select *
    from {{ ref('stg_github_issue') }}
  
), issue_labels as (

    select *
    from {{ ref('issue_labels')}}

), issue_projects as (

    select *
    from {{ ref('issue_projects')}}

), repository as (

    select *
    from {{ ref('stg_github_repository')}}

), milestone as (

    select *
    from {{ ref('stg_github_milestone')}}

), issue_assignees as (

    select *
    from {{ ref('issue_assignees')}}

), issue_open_length as (

    select *
    from {{ ref('issue_open_length')}}

), issue_blocked_time as (

    select *
    from {{ ref('issue_blocked_time')}}

), issue_inbox_time as (

    select *
    from {{ ref('issue_inbox_time')}}

), creator as (

    select *
    from {{ ref('stg_github_user')}}

)

select
  issue.issue_id,
  issue.body,
  issue.closed_at,
  issue.created_at,
  issue.locked,
  issue.milestone_id,
  issue.number,
  issue.repository_id,
  issue.state,
  issue.title,
  issue.updated_at,
  issue.user_id,
  concat('https://github.com/', repository.full_name, '/issues/', cast(issue.number as string)) as url_link,
  issue_open_length.days_issue_opened,
  labels.labels,
  issue_projects.projects,
  repository.full_name as repository,
  milestone.title as milestone,
  milestone.due_on as milestone_due_on,
  issue_assignees.assignees,
  issue_blocked_time.days_blocked,
  issue_inbox_time.inbox_days,
  creator.login as created_by
from issue
left join issue_labels as labels
  on issue.issue_id = labels.issue_id
left join issue_projects
  on issue.issue_id = issue_projects.issue_id
left join repository
  on issue.repository_id = repository.repository_id
left join milestone
  on issue.milestone_id = milestone.milestone_id and issue.repository_id = milestone.repository_id
left join issue_assignees
  on issue.issue_id = issue_assignees.issue_id
left join issue_open_length
  on issue.issue_id = issue_open_length.issue_id
left join issue_blocked_time
  on issue.issue_id = issue_blocked_time.issue_id
left join issue_inbox_time
  on issue.issue_id = issue_inbox_time.issue_id
left join creator on issue.user_id = creator.user_id
where not issue.pull_request
