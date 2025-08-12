{{ config(enabled=var('github__using_repo_team', True)) }}

with base as (

    select * 
    from {{ ref('stg_github__repo_team_tmp') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_github/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_github/macros/).

        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_github__repo_team_tmp')),
                staging_columns=get_repo_team_columns()
            )
        }}
        
    from base
    
), final as (
    
    select 
        repository_id,
        team_id
    from fields
)

select * from final
