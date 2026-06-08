{{ config(enabled=var('github__using_repo_team', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='github_sources',
        single_source_name='github',
        single_table_name='team'
    )
}}
