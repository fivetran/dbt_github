with milestone as (

    select *
    from {{ source('github', 'milestone') }}

), fields as (

    select 
      id,
      title,
      due_on, 
      repository_id
    from milestone
)

select *
from fields