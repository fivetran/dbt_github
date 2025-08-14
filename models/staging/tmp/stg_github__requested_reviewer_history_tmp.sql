{{ config(enabled=var('github__using_requested_reviewer_history', True)) }}

select *
from {{ var('requested_reviewer_history') }}
