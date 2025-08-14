{% macro get_repo_team_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "permission", "datatype": dbt.type_string()},
    {"name": "repository_id", "datatype": dbt.type_int()},
    {"name": "team_id", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
