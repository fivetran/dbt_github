with pull_request_review as (
    select *
    from {{ var('pull_request_review') }}
), 

github_user as (
    select *
    from {{ var('user')}}
),

requested_reviewer_history as (

    select *
    from {{ var('requested_reviewer_history') }}
    where removed = false
)

select
  pull_request_review.pull_request_id,
  {{ fivetran_utils.string_agg( 'github_user.login_name', "', '" )}} as reviewers,
  count(*) as number_of_reviews
from pull_request_review
inner join requested_reviewer_history on pull_request_review.pull_request_id = requested_reviewer_history.pull_request_id
    and pull_request_review.user_id = requested_reviewer_history.requested_id
left join github_user on requested_reviewer_history.requested_id = github_user.user_id
group by 1
