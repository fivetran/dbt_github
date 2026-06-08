{{ config(enabled=var('github__using_issue_label', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='github_sources',
        single_source_name='github',
        single_table_name='issue_label'
    )
}}
