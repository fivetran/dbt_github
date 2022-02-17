with issue_label as (
    select *
    from {{ ref('int_github__issue_label_joined') }}
)

select
  issue_id,
  {{ fivetran_utils.string_agg( 'label', "', '" )}} as labels
from issue_label
group by issue_id
