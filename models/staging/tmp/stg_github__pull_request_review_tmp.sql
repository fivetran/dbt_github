{{
    github.github_union_connections(
        connection_dictionary=var('github_sources'),
        single_source_name='github',
        single_table_name='pull_request_review',
        default_identifier='pull_request_review'
    )
}}
