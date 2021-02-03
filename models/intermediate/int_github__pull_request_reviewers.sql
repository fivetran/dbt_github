with pull_request_review as (
    select *
    from {{ ref('stg_github__pull_request_review') }}
), 

github_user as (
    select *
    from {{ ref('stg_github__user')}}
)

select
  pull_request_review.pull_request_id,
  {{ fivetran_utils.string_agg( 'github_user.login_name', "', '" )}} as reviewers,
  count(*) as number_of_reviews
from pull_request_review
left join github_user on pull_request_review.user_id = github_user.user_id
group by 1
