{{ config(enabled=var('github__using_issue_label', True)) }}

select *
from {{ var('issue_label') }}
