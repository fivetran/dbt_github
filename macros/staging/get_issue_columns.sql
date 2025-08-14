{% macro get_issue_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "body", "datatype": dbt.type_string()},
    {"name": "closed_at", "datatype": dbt.type_timestamp()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "locked", "datatype": "boolean"},
    {"name": "milestone_id", "datatype": dbt.type_int()},
    {"name": "number", "datatype": dbt.type_int()},
    {"name": "pull_request", "datatype": "boolean"},
    {"name": "repository_id", "datatype": dbt.type_int()},
    {"name": "state", "datatype": dbt.type_string()},
    {"name": "title", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "user_id", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
