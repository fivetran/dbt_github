{{ config(enabled=var('github__using_repo_team', True)) }}

with repository as (
    select *
    from {{ ref('stg_github__repository') }}
),

repo_teams as (
    select *
    from {{ ref('stg_github__repo_team') }}
),

teams as (
    select *
    from {{ ref('stg_github__team') }}
),

team_repo as (
    select
        repository.source_relation,
        repository.repository_id,
        repository.full_name as repository,
        teams.name as team_name
    from repository

    left join repo_teams
        on repository.repository_id = repo_teams.repository_id
        and repository.source_relation = repo_teams.source_relation

    left join teams
        on repo_teams.team_id = teams.team_id
        and repo_teams.source_relation = teams.source_relation
),

final as (
    select
        source_relation,
        repository_id,
        repository,
        {{ fivetran_utils.string_agg('team_name', "', '" ) }} as repository_team_names
    from team_repo

    group by 1, 2, 3
)

select *
from final