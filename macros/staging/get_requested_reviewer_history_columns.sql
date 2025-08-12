{% macro get_requested_reviewer_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "actor_id", "datatype": dbt.type_int()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "pull_request_id", "datatype": dbt.type_int()},
    {"name": "removed", "datatype": "boolean"},
    {"name": "requested_id", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
