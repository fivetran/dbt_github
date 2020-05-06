with milestone as (

    select *
    from {{ source('github', 'milestone') }}

), fields as (

    select 
      id as milestone_id,
      title,
      due_on, 
      repository_id
    from milestone
)

select *
from fields