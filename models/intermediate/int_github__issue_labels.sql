with issue_label as (
    select *
    from {{ ref('stg_github__issue_label') }}
)

select
  issue_id,
  {{ fivetran_utils.string_agg( 'label', "', '" )}} as labels
from issue_label
group by issue_id
