{{ config(enabled=var('github__using_repo_team', True)) }}

{{
    github.github_union_connections(
        connection_dictionary=var('github_sources'),
        single_source_name='github',
        single_table_name='repo_team',
        default_identifier='repo_team'
    )
}}
