{% macro get_issue_label_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "actor_id", "datatype": dbt.type_int()},
    {"name": "issue_id", "datatype": dbt.type_int()},
    {"name": "label_id", "datatype": dbt.type_int()},
    {"name": "labeled", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
