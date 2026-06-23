{{ config(enabled=var('github__using_requested_reviewer_history', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='github_sources',
        single_source_name='github',
        single_table_name='requested_reviewer_history'
    )
}}
