<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_github/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Github dbt Package ([Docs](https://fivetran.github.io/dbt_github/))
# 📣 What does this dbt package do?

- Produces modeled tables that leverage Github data from [Fivetran's connector](https://fivetran.com/docs/applications/github) in the format described by [this ERD](https://fivetran.com/docs/applications/github#schemainformation) and builds off of the output from our [github source package](https://github.com/fivetran/dbt_github_source).

- Provides insight into GitHub issues and pull requests by enhancing these core objects with commonly used metrics. 
- Produces metrics tables, which increase understanding of your team's velocity over time. Metrics are available on a daily, weekly, monthly, and quarterly level.
- Generates a comprehensive data dictionary of your source and modeled github data through the [dbt docs site](https://fivetran.github.io/dbt_github/).

<!--section="transform-model"-->
The following table provides a detailed list of all models materialized within this package by default. 
> TIP: See more details about these models in the package's [dbt docs site](https://fivetran.github.io/dbt_github/#!/overview?g_v=1&g_e=seeds).

| **Model**                  | **Description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [github__issues](https://fivetran.github.io/dbt_github/#!/model/model.github.github__issues)     | Each record represents a GitHub issue, enriched with data about its assignees, milestones, and time comparisons.                                             |
| [github__pull_requests](https://fivetran.github.io/dbt_github/#!/model/model.github.github__pull_requests)     | Each record represents a GitHub pull request, enriched with data about its repository, reviewers, and durations between review requests, merges and reviews. |
| [github__daily_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__daily_metrics)     | Each record represents a single day and repository, enriched with metrics about PRs and issues that were created and closed during that period.                              |
| [github__weekly_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__weekly_metrics)    | Each record represents a single week and repository, enriched with metrics about PRs and issues that were created and closed during that period.                             |
| [github__monthly_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__monthly_metrics)   | Each record represents a single month and repository, enriched with metrics about PRs and issues that were created and closed during that period.                            |
| [github__quarterly_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__quarterly_metrics) | Each record represents a single quarter and repository, enriched with metrics about PRs and issues that were created and closed during that period.                          |
<!--section-end-->

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Github connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Step 2: Install the package
Include the following github package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/github
    version: [">=0.7.0", "<0.8.0"]
```

## Step 3: Define database and schema variables
By default, this package runs using your [destination](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile) and the `github` schema. If this is not where your Github data is (for example, if your github schema is named `github_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  github_source:
    github_database: your_database_name
    github_schema: your_schema_name 
```

## Step 4: Disable models for non-existent sources
Your Github connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Github or have actively excluded some tables from your syncs.

If you do not have the `REPO_TEAM` table synced, add the following variable to your `dbt_project.yml` file:

```yml
vars:
    github__using_repo_team: false # by default this is assumed to be true
```

*Note: This package only integrates the above variable. If you'd like to disable other models, please create an [issue](https://github.com/fivetran/dbt_github/issues) specifying which ones.*

## (Optional) Step 5: Additional configurations

<details><summary>Expand for configurations</summary>

### Change the build schema
By default, this package builds the Github staging models within a schema titled (`<target_schema>` + `_stg_github`) and your Github modeling models within a schema titled (`<target_schema>` + `_github`) in your destination. If this is not where you would like your Github data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    github_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    github:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_github_source/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    github_<default_source_table_name>_identifier: your_table_name 
```
</details>

## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™    
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: fivetran/github_source
      version: [">=0.7.0", "<0.8.0"]
    
    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_github/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_github/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.
