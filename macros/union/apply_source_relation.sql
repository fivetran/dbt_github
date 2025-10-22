{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'github') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('github_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("github_database", target.database) }}' || '.'|| '{{ var("github_schema", "github") }}' as source_relation
{% endif %}

{%- endmacro %}