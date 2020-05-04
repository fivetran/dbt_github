with issue as (

    select *
    from {{ ref('stg_github_issue') }}
  
), issue_labels as (

    select *
    from {{ ref('issue_labels')}}

), repository as (

    select *
    from {{ ref('stg_github_repository')}}

), issue_assignees as (

    select *
    from {{ ref('issue_assignees')}}

), issue_open_length as (

    select *
    from {{ ref('issue_open_length')}}

), creator as (

    select *
    from {{ ref('stg_github_user')}}

)

select
  issue.id,
  issue.body,
  issue.closed_at,
  issue.created_at,
  issue.locked,
  issue.number,
  issue.repository_id,
  issue.state,
  issue.title,
  issue.updated_at,
  issue.user_id,
  concat('https://github.com/', repository.full_name, '/issues/', cast(issue.number as string)) as url_link,
  issue_open_length.days_issue_opened,
  labels.labels,
  repository.full_name as repository,
  issue_assignees.assignees,
  creator.login as created_by
from issue
left join issue_labels as labels
  on issue.id = labels.issue_id
left join repository
  on issue.repository_id = repository.id
left join issue_assignees
  on issue.id = issue_assignees.issue_id
left join issue_open_length
  on issue.id = issue_open_length.issue_id
left join creator on issue.user_id = creator.id

where not issue.pull_request
