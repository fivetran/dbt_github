with pull_request_review as (
    select *
    from {{ ref('stg_github__pull_request_review') }}
), 

github_user as (
    select *
    from {{ ref('stg_github__user') }}
),

actual_reviewers as (
  select
    pull_request_review.pull_request_id,
    {{ fivetran_utils.string_agg( 'distinct github_user.login_name', "', '" )}} as reviewers,
    count(*) as number_of_reviews
from pull_request_review
left join github_user on pull_request_review.user_id = github_user.user_id
group by 1
),

{% if var('github__using_requested_reviewer_history', True) %}
requested_reviewer_history as (

    select *
    from {{ ref('stg_github__requested_reviewer_history') }}
    where removed = false
),

requested_reviewers as (
  select
    requested_reviewer_history.pull_request_id,
    {{ fivetran_utils.string_agg( 'distinct github_user.login_name', "', '" )}} as requested_reviewers
from requested_reviewer_history
left join github_user on requested_reviewer_history.requested_id = github_user.user_id
group by 1
),
{% endif %}

joined as (
  select
    actual_reviewers.pull_request_id,
    actual_reviewers.reviewers,
    {% if var('github__using_requested_reviewer_history', True) -%}
    requested_reviewers.requested_reviewers,
    {% else -%} 
    cast(null as {{ dbt.type_string() }}) as requested_reviewers,
    {%- endif %}
    actual_reviewers.number_of_reviews
  from actual_reviewers
  {% if var('github__using_requested_reviewer_history', True) %}
  full outer join requested_reviewers 
    on requested_reviewers.pull_request_id = actual_reviewers.pull_request_id
  {% endif -%}
)

select *
from joined