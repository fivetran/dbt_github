with issue_status_windows as (

    select *
    from {{ ref('issue_status_windows') }}
  
), project as (

    select *
    from {{ ref('stg_github_project') }}
  
), current_status as (

    select
      issue_id,
      project_id,
      array_agg(removed order by valid_until desc)[safe_offset(0)] as most_recent_removed_status
    from issue_status_windows
    group by 1, 2

), current_project_issues_with_ids as (

    select
      issue_id,
      array_agg(distinct project_id) as projects_array
    from issue_status_windows
    where concat(issue_id, '-', project_id) not in ( --projects where the issue has not been removed
      select
        concat(issue_id, '-', project_id) as issue_project
      from current_status
      where most_recent_removed_status = true
    )
    group by 1

)
select
  issue_id,
  string_agg(project.name, ', ') as projects
from current_project_issues_with_ids, unnest(projects_array) as project_id
join project on project_id = project.project_id
group by 1
