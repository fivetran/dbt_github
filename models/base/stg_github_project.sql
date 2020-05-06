with project as (

    select *
    from {{ source('github', 'project') }}

), fields as (

    select
      id as project_id,
      name
    from project
)

select *
from fields