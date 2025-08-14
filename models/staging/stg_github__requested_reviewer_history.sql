{{ config(enabled=var('github__using_requested_reviewer_history', True)) }}

with requested_reviewer_history as (

    select *
    from {{ ref('stg_github__requested_reviewer_history_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_github__requested_reviewer_history_tmp')),
                staging_columns=get_requested_reviewer_history_columns()
            )
        }}

    from requested_reviewer_history

), fields as (

    select 
      pull_request_id,
      cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
      requested_id,
      removed

    from macro
)

select *
from fields