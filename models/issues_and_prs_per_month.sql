with github_issues as (

    select *
    from {{ ref('github_issues') }}

), pull_requests as (

    select *
    from {{ ref('github_pull_requests') }}

), issues_opened_per_month as (

   select 
      date_trunc(date(created_at), month) as month, 
      count(*) as number_issues_opened,
      avg(days_issue_open) as average_length_issue_open,
      max(days_issue_open) as longest_length_issue_open
    from github_issues
    group by 1

), issues_closed_per_month as (

   select 
      date_trunc(date(closed_at), month) as month, 
      count(*) as number_issues_closed
    from github_issues
    where closed_at is not null
    group by 1

), prs_opened_per_month as (

   select 
      date_trunc(date(created_at), month) as month, 
      count(*) as number_prs_opened,
      avg(days_pr_open) as average_length_pr_open,
      max(days_pr_open) as longest_length_pr_open
    from pull_requests
    group by 1

), prs_merged_per_month as (

   select 
      date_trunc(date(merged_at), month) as month, 
      count(*) as number_prs_merged
    from pull_requests
    group by 1

), issues_per_month as (

    select 
      coalesce(issues_opened_per_month.month, 
        issues_closed_per_month.month
      ) as month,
      number_issues_opened,
      number_issues_closed,      
      average_length_issue_open,
      longest_length_issue_open
    from issues_opened_per_month
    full outer join issues_closed_per_month on issues_opened_per_month.month = issues_closed_per_month.month

), prs_per_month as (

    select 
      coalesce(prs_opened_per_month.month, 
        prs_merged_per_month.month
      ) as month,
      number_prs_opened,
      number_prs_merged,
      average_length_pr_open,
      longest_length_pr_open
    from prs_opened_per_month
    full outer join prs_merged_per_month on prs_opened_per_month.month = prs_merged_per_month.month

)

select 
  coalesce(issues_per_month.month, 
    prs_per_month.month
  ) as month,
  coalesce(number_issues_opened, 0) as number_issues_opened,
  coalesce(number_issues_closed, 0) as number_issues_closed,
  average_length_issue_open,
  longest_length_issue_open,
  coalesce(number_prs_opened, 0) as number_prs_opened,
  coalesce(number_prs_merged, 0) as number_prs_merged,
  average_length_pr_open,
  longest_length_pr_open
from issues_per_month 
full outer join prs_per_month on issues_per_month.month = prs_per_month.month
