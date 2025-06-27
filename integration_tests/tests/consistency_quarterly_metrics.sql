{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

-- this test ensures the github__quarterly_metrics end model matches the prior version
with prod as (
    select 
        quarter,
        repository,
        round(number_issues_opened, 0) as number_issues_opened,
        round(number_issues_closed, 0) as number_issues_closed,
        round(avg_days_issue_open, 0) as avg_days_issue_open,
        round(longest_days_issue_open, 0) as longest_days_issue_open,
        round(number_prs_opened, 0) as number_prs_opened,
        round(number_prs_merged, 0) as number_prs_merged,
        round(number_prs_closed_without_merge, 0) as number_prs_closed_without_merge,
        round(avg_days_pr_open, 0) as avg_days_pr_open,
        round(longest_days_pr_open, 0) as longest_days_pr_open

    from {{ target.schema }}_github_prod.github__quarterly_metrics
    where date(quarter) < current_date() -- BQ 
),

dev as (
    select 
        quarter,
        repository,
        round(number_issues_opened, 0) as number_issues_opened,
        round(number_issues_closed, 0) as number_issues_closed,
        round(avg_days_issue_open, 0) as avg_days_issue_open,
        round(longest_days_issue_open, 0) as longest_days_issue_open,
        round(number_prs_opened, 0) as number_prs_opened,
        round(number_prs_merged, 0) as number_prs_merged,
        round(number_prs_closed_without_merge, 0) as number_prs_closed_without_merge,
        round(avg_days_pr_open, 0) as avg_days_pr_open,
        round(longest_days_pr_open, 0) as longest_days_pr_open
        
    from {{ target.schema }}_github_dev.github__quarterly_metrics
    where date(quarter) < current_date() -- BQ
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final