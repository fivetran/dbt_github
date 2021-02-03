with daily_metrics as (
    select *
    from {{ ref('github__daily_metrics') }}
)

select 
  {{ dbt_utils.date_trunc('week', 'day') }} as week, 
  sum(number_issues_opened) as number_issues_opened,
  sum(number_issues_closed) as number_issues_closed,
  sum(sum_days_issue_open) / sum(number_issues_opened) as avg_days_issue_open,
  max(longest_days_issue_open) as longest_days_issue_open,
  sum(number_prs_opened) as number_prs_opened,
  sum(number_prs_merged) as number_prs_merged,
  sum(number_prs_closed_without_merge) as number_prs_closed_without_merge,
  sum(sum_days_pr_open) / sum(number_prs_opened) as avg_days_pr_open,
  max(longest_days_pr_open) as longest_days_pr_open
from daily_metrics 
group by 1
order by 1 desc