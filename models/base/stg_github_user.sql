with user as (

    select *
    from {{ source('github', 'user') }}

), fields as (

    select
      id as user_id,
      login
    from user
)

select *
from fields