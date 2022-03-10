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
