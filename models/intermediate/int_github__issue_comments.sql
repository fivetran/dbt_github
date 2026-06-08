with issue_comment as (
    select *
    from {{ ref('stg_github__issue_comment') }}
)

select
  source_relation,
  issue_id,
  count(*) as number_of_comments
from issue_comment
group by issue_id{{ fivetran_utils.partition_by_source_relation(package_name='github') }}