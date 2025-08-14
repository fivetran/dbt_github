{{ config(enabled=var('github__using_label', True)) }}

select *
from {{ var('label') }}