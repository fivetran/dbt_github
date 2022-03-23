[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 
![dbt-core](https://img.shields.io/badge/dbt_core-version_>=1.0.0_<2.0.0-orange.svg)

# GitHub dbt Package ([Docs](https://dbt-github.netlify.app/))
# 📣 What does this dbt package do?
This package builds off the [dbt_github_source](https://github.com/fivetran/dbt_github_source) staging models and applies transformations that enables you to better understand your GitHub issues and pull requests.  Its main focus is to enhance these two core objects with commonly used metrics. Additionally, the metrics tables let you better understand your team's velocity over time.  These metrics are available on a daily, weekly, monthly and quarterly level. 

This package will materialize the following staging models in your warehouse:

| **model**                  | **description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [github__issues](https://dbt-github.netlify.app/#!/model/model.github.github__issues)             | Each record represents a GitHub issue, enriched with data about its assignees, milestones, and time comparisons.                                             |
| [github__pull_requests](https://dbt-github.netlify.app/#!/model/model.github.github__pull_requests)     | Each record represents a GitHub pull request, enriched with data about its repository, reviewers, and durations between review requests, merges and reviews. |
| [github__daily_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__daily_metrics)     | Each record represents a single day, enriched with metrics about PRs and issues that were created and closed during that period.                              |
| [github__weekly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__weekly_metrics)    | Each record represents a single week, enriched with metrics about PRs and issues that were created and closed during that period.                             |
| [github__monthly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__monthly_metrics)   | Each record represents a single month, enriched with metrics about PRs and issues that were created and closed during that period.                            |
| [github__quarterly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__quarterly_metrics) | Each record represents a single quarter, enriched with metrics about PRs and issues that were created and closed during that period.                          |

# 🤔 Who is the target user of this dbt package?
This package is intended to be leveraged by individuals who want to take advantage of analysis ready models to fuel their reporting needs. The package outputs reporting tables that may be easily linked directly to your BI tool of choice for quick time to value with your GitHub data.

This package models the data in a way that it will effectively answer the majority of your questions. However, it will never answer **all** of your business questions. That being said, you are always able to reference the models from this package and apply your own additional custom transformations to fit your specific reporting needs. If you believe this package should include additional models and believe other users will benefit, I recommend you refer to the [Contributions]() section for information on how to contribute to the open-source package.

# 🎯 How do I use the dbt package?
To effectively install this package and leverage the pre-made models, you will want to follow the below steps:
## Step 1: Requirements 
### Connector
Have the Fivetran GitHub connector syncing data into your warehouse. 
### Database support
This package has been tested on BigQuery, Snowflake and Redshift. Ensure you are using one of these supported databases.

### dbt Version
This dbt package requires you have a functional dbt project that utilizes a dbt version within the respective range `>=1.0.0, <2.0.0`.
  - If you do not have dbt installed, I recommend you refer to the [dbt setup guide]() for details on how to get your first dbt project set up.

## Step 2: Installing the Package
Include the following github package version in your `packages.yml`

```yaml
packages:
  - package: fivetran/github
    version: [">=0.5.0", "<0.6.0"]
```
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Step 3: Configure Your Variables
### Database and Schema Variables
By default, this package will run using your target database and the `github` schema. If this is not where your GitHub data is (perhaps your gitHub schema is `Github_fivetran`), add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  github_source:
    github_database: your_database_name
    github_schema: your_schema_name 
```
### Disabling Model Variables
Your Github connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Github or have actively excluded some tables from your syncs.

If you do not have the `REPO_TEAM` table synced, add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml
config-version: 2

vars:
    github__using_repo_team: false # by default this is assumed to be true
```

*Note: This package only integrates the above variable. If you'd like to disable other models, please create an [issue](https://github.com/fivetran/dbt_github_source/issues) specifying which ones.*

## (Optional) Step 4: Additional Configurations
### Change the Build Schema
By default, this package builds the GitHub staging models within a schema titled (<target_schema> + `_stg_github`) and your GitHub modeling models within a schema titled (<target_schema> + `_github`) in your target database. If this is not where you would like your GitHub staging data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    github_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    github:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

## Step 5: Finish Setup
Your dbt project is now setup to successfully run the dbt package models! You can now execute `dbt run` and `dbt test` to see the models materialize in your warehouse and execute the data integrity tests applied within the package.

## (Optional) Step 6: Orchestrate your package models with Fivetran
Fivetran offers the ability for you to orchestrate your dbt project through the [Fivetran Transformations for dbt Core](https://fivetran.com/docs/transformations/dbt) product. Refer to the linked docs for more information on how to setup your project for orchestration through Fivetran. 

# Package Dependency Matrix
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.

>**If you have any of these dependent packages in your own `packages.yml` I highly recommend you remove them to ensure there are no package version conflicts.**
```
packages:
  - package: fivetran/github_source
    version: [">=0.5.0", "<0.6.0"]
  - package: fivetran/fivetran_utils
    version: [">=0.3.0", "<0.4.0"]
  - package: dbt-labs/dbt_utils
    version: [">=0.8.0", "<0.9.0"]
```
# 🙌 Contributions and Maintenance
## Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github_source/latest/) of the package and refer to the [CHANGELOG](/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Please refer to the [CONTRIBUTING.md](/CONTRIBUTING.md) doc for details on how to effectively contribute to this open source project!

# 🏪 Resources
If you encounter any questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_github_source/issues/new/choose) section to find the right avenue of support for you.
