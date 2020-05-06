with project as (

    select *
    from {{ source('github', 'project') }}

), fields as (

    select
      id,
      name
    from project
)

select *
from fields