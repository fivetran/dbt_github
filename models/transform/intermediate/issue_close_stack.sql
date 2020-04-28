with issue as (
    
    select *
    from {{ ref('stg_github_issue') }}
  
), issue_closed_history as (

    select *
    from {{ ref('stg_issue_closed_history') }}
  
), close_events_stacked as (
    select
      issue_id,
      created_at as updated_at,
      FALSE as closed
    from github.issue
    union all
    select
      issue_id,
      updated_at,
      closed
    from github.issue_closed_history
    union all
    select
      issue_id,
      closed_at as updated_at,
      TRUE as closed
    from issue
    where closed_at is not null

), close_events_stacked_ordered as (
    select
      *,
      row_number() over (partition by issue_id order by updated_at) as issue_event_order /* to avoid ordering issues when updated_at value is present twice */
    from close_events_stacked
)

select
  issue_id,
  updated_at as valid_starting,
  coalesce(lead(updated_at) over (partition by issue_id order by issue_event_order), timestamp_sub(timestamp_add(timestamp(current_date()), interval 1 day), interval 1 millisecond)) as valid_until,
  closed as is_closed
from close_events_stacked_ordered
