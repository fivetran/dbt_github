{{ config(enabled=var('github__using_label', True)) }}

{{
    github.github_union_connections(
        connection_dictionary=var('github_sources'),
        single_source_name='github',
        single_table_name='label',
        default_identifier='label'
    )
}}