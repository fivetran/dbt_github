with issue_comment as (
    select *
    from {{ var('issue_comment') }}
)

select
  issue_id,
  count(*) as number_of_comments
from issue_comment
group by issue_id