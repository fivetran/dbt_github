-- One row per issue, label, and interval start (valid_from)
{{ config(enabled=(var('github__using_issue_label_history', True) and var('github__using_label', True))) }}

with label_intervals as (

    select *
    from {{ ref('int_github__issue_label_intervals') }}

), issue as (

    select *
    from {{ ref('stg_github__issue') }}

), repository as (

    select *
    from {{ ref('stg_github__repository') }}

), label as (

    select *
    from {{ ref('stg_github__label') }}

), github_user as (

    select *
    from {{ ref('stg_github__user') }}

), final as (

    select
        {{ dbt_utils.generate_surrogate_key(['label_intervals.source_relation', 'label_intervals.issue_id', 'label_intervals.label_id', 'label_intervals.valid_from']) }} as issue_label_history_id,
        label_intervals.source_relation,
        label_intervals.issue_id,
        issue.issue_number,
        issue.is_pull_request,
        issue.repository_id,
        repository.full_name as repository,
        label_intervals.label_id,
        label.label as label_name,
        label.description as label_description,
        label.is_default as is_default_label,
        label_intervals.valid_from,
        label_intervals.valid_until,
        label_intervals.is_currently_applied,
        label_intervals.label_application_number,
        label_intervals.actor_id,
        actor.login_name as actor_login_name,
        actor.name as actor_name,
        label_intervals.removed_by_actor_id,
        removed_by_actor.login_name as removed_by_actor_login_name,
        removed_by_actor.name as removed_by_actor_name
    from label_intervals
    left join issue
        on label_intervals.issue_id = issue.issue_id
        and label_intervals.source_relation = issue.source_relation
    left join repository
        on issue.repository_id = repository.repository_id
        and issue.source_relation = repository.source_relation
    left join label
        on label_intervals.label_id = label.label_id
        and label_intervals.source_relation = label.source_relation
    left join github_user as actor
        on label_intervals.actor_id = actor.user_id
        and label_intervals.source_relation = actor.source_relation
    left join github_user as removed_by_actor
        on label_intervals.removed_by_actor_id = removed_by_actor.user_id
        and label_intervals.source_relation = removed_by_actor.source_relation

)

select *
from final
