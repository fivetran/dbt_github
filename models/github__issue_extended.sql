SELECT 
    i.* ,
    ic.issue_content AS original_text
FROM {{  var('issue') }} i 
JOIN {{ ref('int_github__issue_concatenated')}} ic