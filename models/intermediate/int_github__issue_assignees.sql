{{ config(enabled=var('github__using_issue_assignee', True)) }}

with issue_assignee as (
    select *
    from {{ ref('stg_github__issue_assignee') }}
), 

github_user as (
    select *
    from {{ ref('stg_github__user') }}
)

select
  issue_assignee.source_relation,
  issue_assignee.issue_id,
  {{ fivetran_utils.string_agg( 'github_user.login_name', "', '" )}} as assignees
from issue_assignee
join github_user on issue_assignee.user_id = github_user.user_id
  and issue_assignee.source_relation = github_user.source_relation
group by 1, 2
