{{ config(enabled=(var('github__using_issue_label', True) and var('github__using_label', True))) }}

with issue_label as (

    select *
    from {{ ref('stg_github__issue_label') }}

), label as (

    select *
    from {{ ref('stg_github__label') }}

), joined as (

    select
        issue_label.source_relation,
        issue_label.issue_id,
        label.label
    from issue_label
    left join label
        on issue_label.label_id = label.label_id
        and issue_label.source_relation = label.source_relation

)

select *
from joined