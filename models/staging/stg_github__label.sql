{{ config(enabled=var('github__using_label', True)) }}

with issue_label as (

    select *
    from {{ ref('stg_github__label_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_github__label_tmp')),
                staging_columns=get_label_columns()
            )
        }}

    from issue_label

), fields as (

    select 
        id as label_id,
        _fivetran_synced,	
        color,
        description,
        is_default,
        name as label,
        url
    from macro
)

select *
from fields