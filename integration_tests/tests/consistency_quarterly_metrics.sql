{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

-- this test ensures the github__quarterly_metrics end model matches the prior version
with prod as (
    select 
        quarter,
        repository,
        sum(coalesce(number_issues_opened, 0)) as number_issues_opened,
        sum(coalesce(number_issues_closed, 0)) as number_issues_closed,
        sum(coalesce(avg_days_issue_open, 0)) as avg_days_issue_open,
        sum(coalesce(longest_days_issue_open, 0)) as longest_days_issue_open,
        sum(coalesce(number_prs_opened, 0)) as number_prs_opened,
        sum(coalesce(number_prs_merged, 0)) as number_prs_merged,
        sum(coalesce(number_prs_closed_without_merge, 0)) as number_prs_closed_without_merge,
        sum(coalesce(avg_days_pr_open, 0)) as avg_days_pr_open,
        sum(coalesce(longest_days_pr_open, 0)) as longest_days_pr_open

    from {{ target.schema }}_github_prod.github__quarterly_metrics
    where date(quarter) < current_date() -- BQ 
    group by 1, 2
),

dev as (
    select 
        quarter,
        repository,
        sum(coalesce(number_issues_opened, 0)) as number_issues_opened,
        sum(coalesce(number_issues_closed, 0)) as number_issues_closed,
        sum(coalesce(avg_days_issue_open, 0)) as avg_days_issue_open,
        sum(coalesce(longest_days_issue_open, 0)) as longest_days_issue_open,
        sum(coalesce(number_prs_opened, 0)) as number_prs_opened,
        sum(coalesce(number_prs_merged, 0)) as number_prs_merged,
        sum(coalesce(number_prs_closed_without_merge, 0)) as number_prs_closed_without_merge,
        sum(coalesce(avg_days_pr_open, 0)) as avg_days_pr_open,
        sum(coalesce(longest_days_pr_open, 0)) as longest_days_pr_open

    from {{ target.schema }}_github_dev.github__quarterly_metrics
    where date(quarter) < current_date() -- BQ
    group by 1, 2
),

final as (
    select 
        coalesce(prod.quarter, dev.quarter) as quarter,
        prod.number_issues_opened as prod_number_issues_opened,
        dev.number_issues_opened as dev_number_issues_opened,
        prod.number_issues_closed as prod_number_issues_closed,
        dev.number_issues_closed as dev_number_issues_closed,
        prod.avg_days_issue_open as prod_avg_days_issue_open,
        dev.avg_days_issue_open as dev_avg_days_issue_open,
        prod.longest_days_issue_open as prod_longest_days_issue_open,
        dev.longest_days_issue_open as dev_longest_days_issue_open,
        prod.number_prs_opened as prod_number_prs_opened,
        dev.number_prs_opened as dev_number_prs_opened,
        prod.number_prs_merged as prod_number_prs_merged,
        dev.number_prs_merged as dev_number_prs_merged,
        prod.number_prs_closed_without_merge as prod_number_prs_closed_without_merge,
        dev.number_prs_closed_without_merge as dev_number_prs_closed_without_merge,
        prod.avg_days_pr_open as prod_avg_days_pr_open,
        dev.avg_days_pr_open as dev_avg_days_pr_open,
        prod.longest_days_pr_open as prod_longest_days_pr_open,
        dev.longest_days_pr_open as dev_longest_days_pr_open
    from prod
    full outer join dev 
        on dev.repository = prod.repository
        and dev.quarter = prod.quarter
)

select *
from final
where
    abs(prod_number_issues_opened - dev_number_issues_opened) >= .01
    or abs(prod_number_issues_closed - dev_number_issues_closed) >= .01
    or abs(prod_avg_days_issue_open - dev_avg_days_issue_open) >= .01
    or abs(prod_longest_days_issue_open - dev_longest_days_issue_open) >= .01
    or abs(prod_number_prs_opened - dev_number_prs_opened) >= .01
    or abs(prod_number_prs_merged - dev_number_prs_merged) >= .01
    or abs(prod_number_prs_closed_without_merge - dev_number_prs_closed_without_merge) >= .01
    or abs(prod_avg_days_pr_open - dev_avg_days_pr_open) >= .01
    or abs(prod_longest_days_pr_open - dev_longest_days_pr_open) >= .01