{{ config(enabled=var('github__using_issue_assignee', True)) }}

{{
    github.github_union_connections(
        connection_dictionary=var('github_sources'),
        single_source_name='github',
        single_table_name='issue_assignee',
        default_identifier='issue_assignee'
    )
}}
