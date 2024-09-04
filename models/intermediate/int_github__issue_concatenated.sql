WITH assignee_groups AS (
    SELECT 
        ia.issue_id,
        LISTAGG(u.login, ', ') WITHIN GROUP (ORDER BY u.login) AS assignees
    FROM {{ var('issue_assignee') }} ia
    LEFT JOIN {{ var('user') }} u ON ia.user_id = u.id
    GROUP BY ia.issue_id
),
issue_details AS (
    SELECT
        i.id,
        i.created_at,
        i.updated_at,
        i.number,
        i.state,
        i.title,
        i.body, 
        u.login,
        ag.assignees
    FROM {{ var('issue') }} i
    LEFT JOIN {{ var('user') }} u ON i.user_id = u.id
    LEFT JOIN assignee_groups ag ON i.id = ag.issue_id
    
    WHERE NOT i.pull_request 
)
SELECT
    id,
    CONCAT(
        '# ISSUE : ',title,' (#',number,')\n\n',
        'Opened by ',login,' on ',created_at,'\n',
        'Assigned to : ',assignees,'\n',
        'Last updated on ',updated_at,'\n',
        'Issue is currently ',state,'\n\n',
        '## Issue Body : \n',body
    ) AS issue_content
FROM issue_details