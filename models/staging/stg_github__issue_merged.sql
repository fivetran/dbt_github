with issue_merged as (

    select *
    from {{ ref('stg_github__issue_merged_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_github__issue_merged_tmp')),
                staging_columns=get_issue_merged_columns()
            )
        }}

    from issue_merged

), fields as (

    select 
      issue_id,
      cast(merged_at as {{ dbt.type_timestamp() }}) as merged_at

    from macro
)

select *
from fields