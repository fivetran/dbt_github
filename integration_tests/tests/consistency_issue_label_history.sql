{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false) and var('github__using_issue_label_history', true)
) }}

{% set exclude_cols = var('gh_consistency_exclude_columns', []) %}

-- this test ensures the github__issue_label_history end model matches the prior version
with prod as (
    select {{ dbt_utils.star(from=ref('github__issue_label_history'), except=exclude_cols) }}
    from {{ target.schema }}_github_prod.github__issue_label_history
),

dev as (
    select {{ dbt_utils.star(from=ref('github__issue_label_history'), except=exclude_cols) }}
    from {{ target.schema }}_github_dev.github__issue_label_history
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
