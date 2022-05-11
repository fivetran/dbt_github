<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_github/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="Fivetran-Release"
        href="https://fivetran.com/docs/getting-started/core-concepts#releasephases">
        <img src="https://img.shields.io/badge/Fivetran Release Phase-_Beta-orange.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.0.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# GitHub dbt Package ([Docs](https://fivetran.github.io/dbt_github/))
# 📣 What does this dbt package do?
- Produces modeled tables that leverage GitHub data from [Fivetran's connector](https://fivetran.com/docs/applications/github) in the format described by [this ERD](https://docs.google.com/presentation/d/1lx6ez7-x-s-n2JCnCi3SjG4XMmx9ysNUvaNCaWc3I_I/edit#slide=id.g244d368397_0_1) and builds off the output of our [GitHub source package](https://github.com/fivetran/dbt_github_source).
- The above mentioned models enable you to better understand your GitHub issues and pull requests. It achieves this by:
  - Enhancing the Issue and Pull Requests objects with commonly used metrics.
  - Models the Issue and Pull Request data in a way that makes for seamless velocity tracking.
- Generates a comprehensive data dictionary of your source and modeled GitHub data via the [dbt docs site](https://fivetran.github.io/dbt_github/)

Refer to the table below for a detailed view of all models materialized by default within this package. Additionally, check out our [Docs site](https://fivetran.github.io/dbt_github/#!/overview?g_v=1) for more details about these models. 

| **model**                  | **description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [github__issues](https://dbt-github.netlify.app/#!/model/model.github.github__issues)             | Each record represents a GitHub issue, enriched with data about its assignees, milestones, and time comparisons.                                             |
| [github__pull_requests](https://dbt-github.netlify.app/#!/model/model.github.github__pull_requests)     | Each record represents a GitHub pull request, enriched with data about its repository, reviewers, and durations between review requests, merges and reviews. |
| [github__daily_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__daily_metrics)     | Each record represents a single day, enriched with metrics about PRs and issues that were created and closed during that period.                              |
| [github__weekly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__weekly_metrics)    | Each record represents a single week, enriched with metrics about PRs and issues that were created and closed during that period.                             |
| [github__monthly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__monthly_metrics)   | Each record represents a single month, enriched with metrics about PRs and issues that were created and closed during that period.                            |
| [github__quarterly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__quarterly_metrics) | Each record represents a single quarter, enriched with metrics about PRs and issues that were created and closed during that period.                          |

# 🎯 How do I use the dbt package?
To effectively install this package and leverage the pre-made models, you will follow the below steps:
## Step 1: Pre-Requisites
You will need to ensure you have the following before leveraging the dbt package.
- **Connector**: Have the Fivetran GitHub connector syncing data into your warehouse. 
- **Database support**: This package has been tested on **BigQuery**, **Snowflake**, **Redshift**, and **Postgres**. Ensure you are using one of these supported databases.

## Step 2: Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/github
    version: [">=0.5.0", "<0.6.0"]
```
## Step 3: Define Database and Schema Variables
By default, this package will run using your target database and the `github` schema. If this is not where your GitHub data is (perhaps your gitHub schema is `Github_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  github_database: your_database_name
  github_schema: your_schema_name 
```
## Step 4: Disable Models for Non Existent Sources
Your Github connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Github or have actively excluded some tables from your syncs.

If you do not have the `REPO_TEAM` table synced, add the following variable to your root `dbt_project.yml` file:

```yml
vars:
  github__using_repo_team: false # by default this is assumed to be true
```
## (Optional) Step 5: Additional Configurations
<details><summary>Expand for configurations</summary>
    
### Change the Build Schema
By default, this package builds the GitHub staging models within a schema titled (<target_schema> + _stg_github) and your GitHub modeling models within a schema titled (<target_schema> + _github) in your target database. If this is not where you would like your GitHub data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    github_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    github:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
### Change the Source Table References
If an individual source table has a different name than expected (see this projects [dbt_project.yml](https://github.com/fivetran/dbt_github_source/blob/main/dbt_project.yml) variable declarations for expected names), provide the name of the table as it appears in your warehouse to the respecitve variable as identified below:
```yml
vars:
    github_<default_source_table_name>_identifier: your_table_name 
```
</details>

## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Refer to the linked docs for more information on how to setup your project for orchestration through Fivetran. 
</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> **If you have any of these dependent packages in your own `packages.yml` I highly recommend you remove them to ensure there are no package version conflicts.**
```yml
packages:
    - package: fivetran/github_source
      version: [">=0.5.0", "<0.6.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.3.0", "<0.4.0"]

    - package: dbt-labs/dbt_utils
      version: [">=0.8.0", "<0.9.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_github/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you encounter any questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_github/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or send us an email at solutions@fivetran.com.

