with issue_comment as (

    select *
    from {{ ref('stg_github__issue_comment_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_github__issue_comment_tmp')),
                staging_columns=get_issue_comment_columns()
            )
        }}
        {{ github.apply_source_relation() }}

    from issue_comment

), fields as (

    select 
        id as issue_comment_id,
        issue_id,
        user_id,
        created_at

    from macro
)

select *
from fields