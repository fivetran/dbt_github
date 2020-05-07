with issue_close_stack as (

    select *
    from {{ ref('issue_close_stack') }}
  
)

select
  issue_id,
  sum(timestamp_diff(least(valid_until, current_timestamp()), valid_starting, second)/86400) as days_issue_open
from issue_close_stack
  where not is_closed
group by issue_id
