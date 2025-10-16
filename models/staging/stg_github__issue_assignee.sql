{{ config(enabled=var('github__using_issue_assignee', True)) }}

with issue_assignee as (

    select *
    from {{ ref('stg_github__issue_assignee_tmp') }}

), macro as (
    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_github/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_github/macros/).

        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
            {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_github__issue_assignee_tmp')),
                staging_columns=get_issue_assignee_columns()
            )
        }}
        {{ github.apply_source_relation() }}

    from issue_assignee

), fields as (

    select 
      issue_id,
      user_id
    from macro
)

select *
from fields