with issue_project_history as (

    select *
    from {{ ref('stg_github_issue_project_history') }}
  
), card as (

    select *
    from {{ ref('stg_github_card') }}
  
)

select
  issue_project_history.issue_id,
  issue_project_history.project_id,
  issue_project_history.column_name,
  issue_project_history.removed,
  issue_project_history.updated_at as valid_starting,
  coalesce(lead(issue_project_history.updated_at) over (partition by issue_project_history.issue_id, issue_project_history.project_id order by issue_project_history.updated_at),
    if(card.archived, card.updated_at, null),
    current_timestamp()) as valid_until
from issue_project_history
join card on issue_project_history.card_id = card.card_id

