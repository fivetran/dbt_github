with pull_request_review as (

    select *
    from {{ ref('stg_github_pull_request_review') }}
  
), pull_request as (

    select *
    from {{ ref('stg_github_pull_request')}}

), requested_reviewer_history as (

    select *
    from {{ ref('stg_github_requested_reviewer_history')}}

), issue as (

    select *
    from {{ ref('stg_github_issue') }}
  
), issue_merged as (

    select
      issue_id,
      min(merged_at) as merged_at
      from {{ ref('stg_github_issue_merged')}}
    group by 1

), first_request_time as (

    select
      pull_request.issue_id,
      pull_request.pull_request_id,
      min(requested_reviewer_history.created_at) as time_of_first_request,
      min(pull_request_review.submitted_at) as time_of_first_review_post_request,
      -- Finds the first review that is by the requested reviewer and is not a dismissal
      min(if(
            requested_reviewer_history.requested_id = pull_request_review.user_id
            and lower(pull_request_review.state) in ('commented', 'approved', 'changes_requested'),
            pull_request_review.submitted_at,
            NULL)) as time_of_first_requested_reviewer_review
    from pull_request
    join requested_reviewer_history on requested_reviewer_history.pull_request_id = pull_request.pull_request_id
    left join pull_request_review on pull_request_review.pull_request_id = pull_request.pull_request_id
      and pull_request_review.submitted_at > requested_reviewer_history.created_at
    group by 1, 2

)

select
  first_request_time.issue_id,
  merged_at,
  timestamp_diff(coalesce(time_of_first_review_post_request, current_timestamp()),time_of_first_request, second)/3600 as hours_first_review_post_request,
  --Finds time between first request for review and the review action, uses current_timestamp is no action yet
  timestamp_diff(
    least(
    coalesce(time_of_first_requested_reviewer_review, current_timestamp()),
    coalesce(issue.closed_at, current_timestamp())
  ), time_of_first_request, second)/3600 as hours_first_action_post_request,
  timestamp_diff(merged_at, time_of_first_request, second)/3600 as hours_request_review_to_merge
from first_request_time
join issue on first_request_time.issue_id = issue.issue_id
left join issue_merged on first_request_time.issue_id = issue_merged.issue_id
