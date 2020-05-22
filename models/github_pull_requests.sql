with issue_joined as (

    select *
    from {{ ref('github_issue_joined') }}  
)

select
  *
from issue_joined
where is_pull_request
