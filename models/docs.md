{% docs source_relation %} Identifies the record's source. {% enddocs %}

{% docs issue_id %} Foreign key that references the issue table. The issue can be a regular issue or a pull request. {% enddocs %}

{% docs label_id %} Foreign key that references the label table. {% enddocs %}

{% docs _fivetran_synced %} Timestamp of the record being synced by Fivetran. {% enddocs %}