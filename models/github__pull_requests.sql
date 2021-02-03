with issue_joined as (
    select *
    from {{ ref('int_github__issue_joined') }}  
)

select
  *
from issue_joined
where is_pull_request
