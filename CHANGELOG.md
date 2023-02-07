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
