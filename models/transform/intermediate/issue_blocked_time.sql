with issue_label_history as (

    select *
    from {{ ref('stg_github_issue_label_history') }}
  
), issue_label_times as (

    select
      issue_id,
      label,
      updated_at as valid_starting,
      lead(issue_label_history.updated_at) over (partition by issue_label_history.issue_id, label order by issue_label_history.updated_at) as valid_until,
      labeled
    from issue_label_history
    order by updated_at

)

select
  issue_id,
  sum(timestamp_diff(coalesce(valid_until, current_timestamp()), valid_starting, second)/86400) as days_blocked
from issue_label_times
where labeled
  and lower(label) like '%blocked%'
group by 1
