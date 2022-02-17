with issue_label as (

    select *
    from {{ var('issue_label') }}

), label as (

    select *
    from {{ var('label') }}

), joined as (

    select 
        issue_label.issue_id,
        label.label
    from issue_label
    left join label 
        on issue_label.label_id = label.label_id

)

select *
from joined