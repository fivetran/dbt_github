with pull_request_review as (

    select *
    from {{ ref('stg_github_pull_request_review') }}
  
), user as (

    select *
    from {{ ref('stg_github_user')}}

)

select
  pull_request_id,
  string_agg(login, ', ') as reviewers,
  count(*) as number_of_reviews
from pull_request_review
left join user on pull_request_review.user_id = user.user_id
group by 1
