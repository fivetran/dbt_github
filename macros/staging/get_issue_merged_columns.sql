{% macro get_issue_merged_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "actor_id", "datatype": dbt.type_int()},
    {"name": "commit_sha", "datatype": dbt.type_string()},
    {"name": "issue_id", "datatype": dbt.type_int()},
    {"name": "merged_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
