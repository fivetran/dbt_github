with pull_request as (

    select *
    from {{ source('github', 'pull_request') }}

), fields as (

    select 
      id as pull_request_id,
      issue_id,
      base_repo_id,
      head_repo_id,
      head_user_id
    from pull_request
)

select *
from fields