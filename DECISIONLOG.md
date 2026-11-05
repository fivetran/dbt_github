## Decision Log

### Building label intervals in `github__issue_label_history`
The `ISSUE_LABEL_HISTORY` source table records one event each time a label is added to or removed from an issue or pull request. The `github__issue_label_history` model turns these events into one row for each period a label is applied. We made the following decisions when building those periods:

- **Consecutive duplicate events are collapsed.** The source can record the same action more than once in a row. For example, a label is added twice with no removal in between. We keep only the first event in each run of duplicates. A repeated add does not start a new period, and a repeated removal does not end one.

- **Removals with no earlier add are dropped.** If the first event for an issue and label is a removal, the label was applied before the history starts. We drop that removal because the start of its period is unknown.

- **Events with a null `label_id` are excluded.** The source can record an event with only the label name and no `label_id`. Including them would add a second, merged set of periods with no label ID, so we exclude them.

- **Adds sort before removals on the same timestamp.** When an add and a removal share the same `updated_at` value, we order the add first. This produces a zero-length period instead of an orphan removal followed by an open period.

Each period starts at `valid_from`, the time of the add. It ends at `valid_until`, the time of the next removal. If the label is still applied, `valid_until` is `null` and `is_currently_applied` is `true`. `label_application_number` counts how many times the label has been applied to the issue, starting at 1.
