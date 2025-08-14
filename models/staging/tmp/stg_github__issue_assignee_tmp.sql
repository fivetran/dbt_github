{{ config(enabled=var('github__using_issue_assignee', True)) }}

select *
from {{ var('issue_assignee') }}
