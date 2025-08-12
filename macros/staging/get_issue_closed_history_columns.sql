{% macro get_issue_closed_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "actor_id", "datatype": dbt.type_int()},
    {"name": "closed", "datatype": "boolean"},
    {"name": "commit_sha", "datatype": dbt.type_string()},
    {"name": "issue_id", "datatype": dbt.type_int()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
