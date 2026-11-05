{{ config(enabled=(var('github__using_issue_label_history', True) and var('github__using_label', True))) }}

with label_history as (

    -- Events with a null label_id duplicate an event that has the label_id (same issue, time, action, and actor).
    -- Keeping them would build a second, merged set of intervals for every label recorded this way.
    select *
    from {{ ref('stg_github__issue_label_history') }}
    where label_id is not null

), ordered_events as (

    select
        source_relation,
        issue_id,
        label_id,
        updated_at,
        is_labeled,
        actor_id,
        lag(is_labeled) over (
            partition by issue_id, label_id {{ fivetran_utils.partition_by_source_relation(package_name='github') }}
            order by updated_at, is_labeled desc
        ) as previous_is_labeled
    from label_history

), deduped_events as (

    -- Keeps the first add of a repeated add and the first removal of a repeated removal.
    -- Drops a removal that has no earlier add, since its interval has no known start.
    select *
    from ordered_events
    where (previous_is_labeled is null and is_labeled)
        or (previous_is_labeled is not null and is_labeled != previous_is_labeled)

), intervals as (

    -- After deduping, events alternate add/remove, so the next event after an add is always its removal.
    select
        source_relation,
        issue_id,
        label_id,
        is_labeled,
        updated_at as valid_from,
        actor_id,
        lead(updated_at) over (
            partition by issue_id, label_id {{ fivetran_utils.partition_by_source_relation(package_name='github') }}
            order by updated_at, is_labeled desc
        ) as valid_until,
        lead(actor_id) over (
            partition by issue_id, label_id {{ fivetran_utils.partition_by_source_relation(package_name='github') }}
            order by updated_at, is_labeled desc
        ) as removed_by_actor_id
    from deduped_events

), applied_intervals as (

    select
        source_relation,
        issue_id,
        label_id,
        valid_from,
        valid_until,
        actor_id,
        removed_by_actor_id
    from intervals
    where is_labeled

), final as (

    select
        source_relation,
        issue_id,
        label_id,
        valid_from,
        valid_until,
        valid_until is null as is_currently_applied,
        row_number() over (
            partition by issue_id, label_id {{ fivetran_utils.partition_by_source_relation(package_name='github') }}
            order by valid_from
        ) as label_application_number,
        actor_id,
        removed_by_actor_id
    from applied_intervals

)

select *
from final
