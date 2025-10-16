with pull_request_review as (

    select *
    from {{ ref('stg_github__pull_request_review_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_github__pull_request_review_tmp')),
                staging_columns=get_pull_request_review_columns()
            )
        }}
        {{ github.apply_source_relation() }}

    from pull_request_review

), fields as (

    select
        source_relation,
        id as pull_request_review_id,
        pull_request_id,
        cast(submitted_at as {{ dbt.type_timestamp() }}) as submitted_at,
        state,
        user_id
    from macro
)

select *
from fields