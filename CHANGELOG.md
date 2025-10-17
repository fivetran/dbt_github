# dbt_github v1.1.0

## Schema/Data Change
**1 total change • 0 possible breaking changes**

| Data Model(s) | Change type | Old | New | Notes |
| ------------- | ----------- | ----| --- | ----- |
| All models | New column | | `source_relation` | Identifies the source connection when using multiple Github connections |

## Feature Update
- **Union Data Functionality**: This release supports running the package on multiple GitHub source connections. See the [README](https://github.com/fivetran/dbt_github/tree/main?tab=readme-ov-file#step-3-define-database-and-schema-variables) for details on how to leverage this feature.

# dbt_github v1.0.0

[PR #67](https://github.com/fivetran/dbt_github/pull/67) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/github_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/github_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/github_source` package will also need to be removed or updated to reference this package.
  - Update any github_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_github/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_github.yml`.

### Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_github v0.9.1

[PR #64](https://github.com/fivetran/dbt_github/pull/64) includes the following updates:

## Feature Updates
- Added the following variables to account for potentially missing tables. For dbt Core users, each is `True` by default and will need to be set to `False` in the root project's `dbt_project.yml`. For Fivetran Quickstart users, they will be dynamically enabled/disabled based on the presence of the associated source table.
  - `github__using_issue_assignee`: Disable if missing `ISSUE_ASSIGNEE`
  - `github__using_issue_label`: Disable if missing `ISSUE_LABEL`
  - `github__using_label`: Disable if missing `LABEL`
  - `github__using_requested_reviewer_history`: Disable if missing `REQUESTED_REVIEWER_HISTORY`

## Under the Hood
- Updated package maintainer PR template.
- Added new variables to the `quickstart.yml` file.
- Added consistency validation tests for the `github__daily/weeky/monthly/quarterly_metrics` models.

# dbt_github v0.9.0

[PR #63](https://github.com/fivetran/dbt_github/pull/63) includes the following updates:

## Breaking Change for dbt Core < 1.9.6

> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([GitHub Source v0.9.0](https://github.com/fivetran/dbt_github_source/releases/tag/v0.9.0)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `github` in file
`models/src_github.yml`. The `freshness` top-level property should be moved
into the `config` of `github`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running GitHub freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `github` package. Pin your dependency on v0.8.1 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `github` source and apply freshness via the previous release top-level property route. This will require you to copy and paste the entirety of the previous release `src_github.yml` file and add an `overrides: github_source` property.

## Documentation
- Added Quickstart model counts to README. ([#60](https://github.com/fivetran/dbt_github/pull/60))
- Corrected references to connectors and connections in the README. ([#60](https://github.com/fivetran/dbt_github/pull/60))

## Under the Hood:
- Updates to ensure integration tests use latest version of dbt.

# dbt_github v0.8.1  
This release contains the following updates:

## Bug Fixes 
- Replaced the deprecated `dbt_current_timestamp.backcompat()` macro with the up-to-date `dbt_current_timestamp`. The deprecated macro occasionally returned the system timezone instead of the expected UTC timestamp, leading to incorrect downstream metrics like negative values for `days_issue_open`. [PR #58](https://github.com/fivetran/dbt_github/pull/58)
- Updated the join type in `int_github__pull_request_times` to ensure pull requests without explicitly requested reviewers are no longer dropped. [PR #57](https://github.com/fivetran/dbt_github/pull/57)

## Under the Hood:
- Added consistency tests for `github__issues` and `github__pull_requests` to ensure new changes don't change the output of either model. (Some measures are omitted from the comparison tests, since they're measures based on the `current_timestamp`, which differs between validation test runs). [PR #58](https://github.com/fivetran/dbt_github/pull/58)

## Contributors
- [@samkessaram](https://github.com/samkessaram) ([PR #57](https://github.com/fivetran/dbt_github/pull/57))

# dbt_github v0.8.0
[PR #53](https://github.com/fivetran/dbt_github/pull/53) contains the following updates:

## 🚨 Breaking Change 🚨
- For consistency with other Fivetran packages, added default target schemas in `dbt_project.yml`. This is a breaking change since the model outputs will now be stored in a schema called `<your target schema>_github` by default. You will need to update any of your downstream use cases to point to the new schema.
  - Refer to [the Change the Build Schema section](https://github.com/fivetran/dbt_github/blob/main/README.md#change-the-build-schema) of the README for instructions on how to adjust the output schema.

## Under the Hood:
- Updated the maintainer PR template to the current format.
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([PR #49](https://github.com/fivetran/dbt_github/pull/49))
- Updated the `quickstart.yml` file to allow for automated Quickstart data model deployments. ([PR #51](https://github.com/fivetran/dbt_github/pull/51))

## Contributors
- [@rajan-lw](https://github.com/rajan-lw) ([PR #48](https://github.com/fivetran/dbt_github/pull/48))

# dbt_github v0.7.0

## 🚨 Breaking Change 🚨
- Updated the following models to aggregate at the `repository` grain in addition to their time period grain. ([#42](https://github.com/fivetran/dbt_github/pull/42), [#43](https://github.com/fivetran/dbt_github/pull/43))
  - `github__daily_metrics`
  - `github__weekly_metrics`
  - `github__monthly_metrics`
  - `github__quarterly_metrics`
## 🎉 Features
- Added column `requested_reviewers` to provide a list of users that were requested to review on a pull request. This is to supplement the column `reviewers`, which provides a list of users that have submitted a reivew, whether or not they were requested to. ([#44](https://github.com/fivetran/dbt_github/pull/44))
- PostgreSQL compatibility! ([#44](https://github.com/fivetran/dbt_github/pull/44))
## 🔧 Bug Fix
- Updated model `int_github__pull_request_reviewers` so that the list of reviewers generated does not contain duplicate usernames. ([#44](https://github.com/fivetran/dbt_github/pull/44))
## 🚘 Under the Hood
- For the metrics models that were updated, added unique-combination-of-column tests for the combination of the time period and repository. ([#44](https://github.com/fivetran/dbt_github/pull/44))
- Removed uniqueness tests on time period in metrics models in favor of the combo test. ([#44](https://github.com/fivetran/dbt_github/pull/44))
- Removed ordering in metrics models to improve efficiency. ([#44](https://github.com/fivetran/dbt_github/pull/44))
## 📝 Contributors 
- @onimsha ([#42](https://github.com/fivetran/dbt_github/pull/42))

# dbt_github v0.6.0
[PR #35](https://github.com/fivetran/dbt_github/pull/35) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
## 🎉 Documentation and Feature Updates 🎉:
- Updated README documentation for easier navigation and dbt package setup. [#35](https://github.com/fivetran/dbt_github/pull/35)
- Added Databricks compatibility. [#38](https://github.com/fivetran/dbt_github/pull/38)

# dbt_github v0.5.1
## Fixes
- The `url_link` logic within `int_github__issue_joined` was focused on only providing the correct url for pull requests. This update includes a `case when` statement to provide the accurate url logic for both Issues and Pull Requests. ([#31](https://github.com/fivetran/dbt_github/pull/31))

## Contributors
- [@jackiexsun](https://github.com/jackiexsun) ([#31](https://github.com/fivetran/dbt_github/pull/31))

# dbt_github v0.5.0
## 🚨 Breaking Changes 🚨
- The addition of the `label` source model results in the reference within `int_github__issue_label` to break. As a result, with the addition of upstream changes within `dbt_github_source` and the new `int_github__issue_label_join` model this issue has been resolved. ([#26](https://github.com/fivetran/dbt_github/pull/26))
  - Please note: It is important you kick off a historical resync of your connector to account for the [connector changes](https://fivetran.com/docs/applications/github/changelog#april2021) from April 2021.

## Fixes
- The `int_github__issue_comment` model was referencing the `stg_github__issue_label` model to produce the total count of comments. This has been fixed to correctly reference the `stg_github__issue_comment` model instead. ([#26](https://github.com/fivetran/dbt_github/pull/26))

## Under the Hood
- All references to the staging models within the package have been updated to refer to the variable instead. This will allow for more dynamic functionality of the package. ([#26](https://github.com/fivetran/dbt_github/pull/26))
# dbt_github v0.4.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_github_source`. Additionally, the latest `dbt_github_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_github v0.1.0 -> v0.3.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
