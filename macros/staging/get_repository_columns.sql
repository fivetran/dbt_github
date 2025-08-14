{% macro get_repository_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "archived", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "default_branch", "datatype": dbt.type_string()},
    {"name": "description", "datatype": dbt.type_string()},
    {"name": "fork", "datatype": "boolean"},
    {"name": "full_name", "datatype": dbt.type_string()},
    {"name": "homepage", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "language", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "owner_id", "datatype": dbt.type_int()},
    {"name": "private", "datatype": "boolean"}
] %}

{{ return(columns) }}

{% endmacro %}
