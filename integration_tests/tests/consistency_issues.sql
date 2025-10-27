{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

-- the differences in prod/dev run times will lead to discrepancies because it leverages current_timestamp, and string aggs don't always have the same order
{% set exclude_cols = ['days_issue_open', 'labels', 'repository_team_names', 'assignees'] 
    + var('gh_consistency_exclude_columns', []) 
    %}

-- this test ensures the github__issues end model matches the prior version
with prod as (
    select {{ dbt_utils.star(from=ref('github__issues'), except=exclude_cols) }}
    from {{ target.schema }}_github_prod.github__issues
    where date(updated_at) < date({{ dbt.current_timestamp() }})
),

dev as (
    select {{ dbt_utils.star(from=ref('github__issues'), except=exclude_cols) }}
    from {{ target.schema }}_github_dev.github__issues
    where date(updated_at) < date({{ dbt.current_timestamp() }})
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