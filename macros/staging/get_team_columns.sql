{% macro get_team_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "description", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "org_id", "datatype": dbt.type_int()},
    {"name": "parent_id", "datatype": dbt.type_int()},
    {"name": "privacy", "datatype": dbt.type_string()},
    {"name": "slug", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
