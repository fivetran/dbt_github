{{ config(enabled=var('github__using_repo_team', True)) }}

select * 
from {{ var('repo_team') }}
