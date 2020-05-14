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
  issue.issue_id,
  issue.body,
  issue.closed_at,
  issue.created_at,
  issue.number,
  issue.state,
  issue.title,
  issue.updated_at,
  concat('https://github.com/', repository.full_name, '/issues/', cast(issue.number as string)) as url_link,
  issue_open_length.days_issue_open,
  issue_open_length.number_of_times_reopened,
  issue_labels.labels,
  repository.full_name as repository,
  issue_assignees.assignees,
  creator.login_name as creator_login_name,
  creator.name as creator_name,
  creator.company as creator_company
from issue
left join issue_labels
  on issue.issue_id = issue_labels.issue_id
join repository
  on issue.repository_id = repository.repository_id
left join issue_assignees
  on issue.issue_id = issue_assignees.issue_id
left join issue_open_length
  on issue.issue_id = issue_open_length.issue_id
left join creator 
  on issue.user_id = creator.user_id
where not issue.pull_request
