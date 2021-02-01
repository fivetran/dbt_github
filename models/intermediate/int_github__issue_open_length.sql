with issue as (
    select *
    from {{ ref('stg_github__issue') }}
), 

issue_closed_history as (
    select *
    from {{ ref('stg_github__issue_closed_history') }}
), 

close_events_stacked as (
    select   
      issue_id,
      created_at as updated_at,
      false as is_closed
    from issue -- required because issue_closed_history table does not have a line item for when the issue was opened
    union all
    select
      issue_id,
      updated_at,
      is_closed
    from issue_closed_history
), 

close_events_with_timestamps as (
  select
    issue_id,
    updated_at as valid_starting,
    coalesce(lead(updated_at) over (partition by issue_id order by updated_at), {{ dbt_utils.current_timestamp() }}) as valid_until,
    is_closed
  from close_events_stacked
)

select
  issue_id,
  sum({{ dbt_utils.datediff('valid_starting', 'valid_until', 'second') }}) /60/60/24 as days_issue_open,
  count(*) - 1 as number_of_times_reopened
from close_events_with_timestamps
  where not is_closed
group by issue_id