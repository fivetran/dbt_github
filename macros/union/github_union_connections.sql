{% macro github_union_connections(connection_dictionary, single_source_name, single_table_name, default_identifier=single_table_name) %}

{{ adapter.dispatch('github_union_connections', 'github') (connection_dictionary, single_source_name, single_table_name, default_identifier) }}

{%- endmacro %}

{% macro default__github_union_connections(connection_dictionary, single_source_name, single_table_name, default_identifier=single_table_name) %}

{%- set exception_warning = "\n\nPlease be aware: The " ~ single_source_name|upper ~ "." ~ single_table_name|upper ~ " table was not found in your schema(s). The Fivetran Data Model will create a completely empty staging model as to not break downstream transformations. To turn off these warnings, set the `fivetran__remove_empty_table_warnings` variable to TRUE (see https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source for details).\n"%}
{%- set using_empty_table_warnings = (execute and not var('fivetran__remove_empty_table_warnings', false)) %}
{%- set using_unioning = connection_dictionary is not none -%}

{%- if using_unioning %}
{# For unioning #}
    {%- set relations = [] -%}
    {%- for connection in connection_dictionary -%}

    {% if var('has_defined_sources', false) %}
        {%- set database = source(connection.name, single_table_name).database %}
        {%- set schema = source(connection.name, single_table_name).schema %}
        {%- set identifier = source(connection.name, single_table_name).identifier %}
    {%- else %}
        {%- set database = connection.database if connection.database else target.database %}
        {%- set schema = connection.schema if connection.schema else single_source_name %}
        {%- set identifier = default_identifier %}
    {%- endif %}
    
    {%- set relation=adapter.get_relation(
        database=database,
        schema=schema,
        identifier=identifier
        )
    -%}

    {%- if relation is not none -%}
        {%- do relations.append(relation) -%}
    {%- endif -%}

    -- ** Values passed to adapter.get_relation:
    {{ '-- full-identifier_var: ' ~ identifier_var }}
    {{ '-- database: ' ~ database }}
    {{ '-- schema: ' ~ schema }}
    {{ '-- identifier: ' ~ identifier }}

    {%- endfor -%}

    {%- if relations != [] -%}
        {{ github.github_union_relations(relations) }}

    {%- else -%}
        {{ exceptions.warn(exception_warning) if using_empty_table_warnings }}

        select
            cast(null as {{ dbt.type_string() }}) as _dbt_source_relation
        limit {{ '0' if target.type != 'redshift' else '1' }}
    {%- endif -%}

{% else %}
{# Not unioning #}

    {% set identifier_var = single_source_name + "_" + single_table_name + "_identifier"%}
    {%- set database = source(single_source_name, single_table_name).database %}
    {%- set schema =   source(single_source_name, single_table_name).schema %}
    {%- set identifier = source(single_source_name, single_table_name).identifier %}

    {%- set relation=adapter.get_relation(
        database=database,
        schema=schema,
        identifier=identifier
        )
    -%}

    -- ** Values passed to adapter.get_relation:
    {{ '-- full-identifier_var: ' ~ identifier_var }}
    {{ '-- database: ' ~ database }}                            
    {{ '-- schema: ' ~ schema }}
    {{ '-- identifier: ' ~ identifier }}

    {% if relation is not none -%}
        select
            {{ dbt_utils.star(from=source(single_source_name, single_table_name)) }}
        from {{ source(single_source_name, single_table_name) }} as source_table

    {% else %}
        {{ exceptions.warn(exception_warning) if using_empty_table_warnings }}

        select
            cast(null as {{ dbt.type_string() }}) as _dbt_source_relation
        limit {{ '0' if target.type != 'redshift' else '1' }}
    {%- endif -%}
{% endif -%}

{%- endmacro %}