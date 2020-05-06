with issue_status_windows as (

    select *
    from {{ ref('issue_status_windows') }}
  
)

select
  issue_id,
  sum(timestamp_diff(valid_until, valid_starting, second)/86400) as inbox_days
from issue_status_windows
where upper(column_name) like '%INBOX%'
  and not removed
group by 1
