--To disable this model, set the github__using_issue_label_history variable within your dbt_project.yml file to False.
{{ config(enabled=var('github__using_issue_label_history', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='github_sources',
        single_source_name='github',
        single_table_name='issue_label_history'
    )
}}
