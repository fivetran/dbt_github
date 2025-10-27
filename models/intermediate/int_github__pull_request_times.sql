with issue as (
    select *
    from {{ ref('stg_github__issue') }}
), 

issue_merged as (
    select
      source_relation,
      issue_id,
      min(merged_at) as merged_at
      from {{ ref('stg_github__issue_merged') }}
    group by 1, 2
)

{% if var('github__using_requested_reviewer_history', True) %}
{# This is only used in conjunction with requested_reviewer_history #}
, pull_request_review as (
    select *
    from {{ ref('stg_github__pull_request_review') }}
), 

{# This is only used in conjunction with requested_reviewer_history #}
pull_request as (
    select *
    from {{ ref('stg_github__pull_request') }}
), 

requested_reviewer_history as (
    select *
    from {{ ref('stg_github__requested_reviewer_history') }}
    where not removed
), 

first_request_time as (
    select
      pull_request.source_relation,
      pull_request.issue_id,
      pull_request.pull_request_id,
      -- Finds the first review that is by the requested reviewer and is not a dismissal
      min(case when requested_reviewer_history.requested_id = pull_request_review.user_id then
          case when lower(pull_request_review.state) in ('commented', 'approved', 'changes_requested')
                then pull_request_review.submitted_at end
      else null end) as time_of_first_requested_reviewer_review,
      min(requested_reviewer_history.created_at) as time_of_first_request,
      min(pull_request_review.submitted_at) as time_of_first_review_post_request
    from pull_request
    left join requested_reviewer_history 
      on requested_reviewer_history.pull_request_id = pull_request.pull_request_id
      and requested_reviewer_history.source_relation = pull_request.source_relation
    left join pull_request_review
      on pull_request_review.pull_request_id = pull_request.pull_request_id
      and pull_request_review.source_relation = pull_request.source_relation
      and pull_request_review.submitted_at > requested_reviewer_history.created_at
      and pull_request_review.source_relation = requested_reviewer_history.source_relation
    group by 1, 2, 3
)

select
  first_request_time.source_relation,
  first_request_time.issue_id,
  issue_merged.merged_at,
  {{ dbt.datediff(
                        'first_request_time.time_of_first_request',
                        "coalesce(first_request_time.time_of_first_review_post_request, " ~ dbt.current_timestamp() ~ ")",
                        'second')
  }}/ 60/60 as hours_request_review_to_first_review,
  {{ dbt.datediff(
                        'first_request_time.time_of_first_request',
                        "least(
                            coalesce(first_request_time.time_of_first_requested_reviewer_review, " ~ dbt.current_timestamp() ~ "),
                            coalesce(issue.closed_at, " ~ dbt.current_timestamp() ~ "))",
                        'second')
  }} / 60/60 as hours_request_review_to_first_action,
  {{ dbt.datediff('first_request_time.time_of_first_request', 'merged_at', 'second') }}/ 60/60 as hours_request_review_to_merge
from first_request_time
join issue 
  on first_request_time.issue_id = issue.issue_id
  and first_request_time.source_relation = issue.source_relation
left join issue_merged 
  on first_request_time.issue_id = issue_merged.issue_id
  and first_request_time.source_relation = issue_merged.source_relation

{%- else %}
{# Just select the issue and merge date if requested reviewer data is not available #}
select
  issue.source_relation,
  issue.issue_id,
  issue_merged.merged_at
from issue
left join issue_merged 
  on issue_merged.issue_id = issue.issue_id
  and issue_merged.source_relation = issue.source_relation
{% endif -%}