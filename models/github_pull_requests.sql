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

), pull_request_times as (

    select *
    from {{ ref('pull_request_times')}}

), pull_request_reviewers as (

    select *
    from {{ ref('pull_request_reviewers')}}

), pull_request as (

    select *
    from {{ ref('stg_github_pull_request')}}

)

select
  issue.issue_id,
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
  creator.login as created_by,
  hours_first_review_post_request,
  hours_first_action_post_request,
  hours_request_review_to_merge,
  merged_at,
  reviwers,
  number_of_reviews
from issue
left join issue_labels as labels
  on issue.issue_id = labels.issue_id
left join repository
  on issue.repository_id = repository.repository_id
left join issue_assignees
  on issue.issue_id = issue_assignees.issue_id
left join issue_open_length
  on issue.issue_id = issue_open_length.issue_id
left join creator 
  on issue.user_id = creator.user_id
left join pull_request
  on issue.issue_id = pull_request.issue_id
left join pull_request_times
  on issue.issue_id = pull_request_times.issue_id
left join pull_request_reviewers
  on pull_request.pull_request_id = pull_request_reviewers.pull_request_id
where issue.pull_request
