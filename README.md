# GitHub dbt Package ([Docs](https://fivetran.github.io/dbt_github/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_github/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that leverage GitHub data from [Fivetran's connector](https://fivetran.com/docs/applications/github) in the format described by [this ERD](https://fivetran.com/docs/applications/github#schemainformation).
- Provides insight into GitHub issues and pull requests by enhancing these core objects with commonly used metrics.
- Produces metrics tables, which increase understanding of your team's velocity over time. Metrics are available on a daily, weekly, monthly, and quarterly level.
- Generates a comprehensive data dictionary of your source and modeled github data through the [dbt docs site](https://fivetran.github.io/dbt_github/).

<!--section="github_transformation_model-->
The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_github/#!/overview?g_v=1&g_e=seeds).

| **Table**                  | **Description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [github__issues](https://fivetran.github.io/dbt_github/#!/model/model.github.github__issues)     | Each record represents a GitHub issue, enriched with data about its assignees, milestones, and time comparisons.                                             |
| [github__pull_requests](https://fivetran.github.io/dbt_github/#!/model/model.github.github__pull_requests)     | Each record represents a GitHub pull request, enriched with data about its repository, reviewers, and durations between review requests, merges and reviews. |
| [github__daily_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__daily_metrics)     | Each record represents a single day and repository, enriched with metrics about PRs and issues that were created and closed during that period.                              |
| [github__weekly_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__weekly_metrics)    | Each record represents a single week and repository, enriched with metrics about PRs and issues that were created and closed during that period.                             |
| [github__monthly_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__monthly_metrics)   | Each record represents a single month and repository, enriched with metrics about PRs and issues that were created and closed during that period.                            |
| [github__quarterly_metrics](https://fivetran.github.io/dbt_github/#!/model/model.github.github__quarterly_metrics) | Each record represents a single quarter and repository, enriched with metrics about PRs and issues that were created and closed during that period.                          |

### Materialized Models
Each Quickstart transformation job run materializes 34 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran GitHub connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package
Include the following github package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/github
    version: [">=1.1.0", "<1.2.0"] # we recommend using ranges to capture non-breaking changes automatically
```

> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/github_source` in your `packages.yml` since this package has been deprecated.

### Step 3: Define database and schema variables

#### Option A: Single connection
By default, this package runs using your [destination](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile) and the `github` schema. If this is not where your GitHub data is (for example, if your github schema is named `github_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  github:
    github_database: your_database_name
    github_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple GitHub connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the github_sources variable in your root dbt_project.yml file:

```yml
# dbt_project.yml

vars:
  github:
    github_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

##### Recommended: Incorporate unioned sources into DAG
> *If you are running the package through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore), the below step is necessary in order to synchronize model runs with your GitHub connections. Alternatively, you may choose to run the package through Fivetran [Quickstart](https://fivetran.com/docs/transformations/quickstart), which would create separate sets of models for each GitHub source rather than one set of unioned models.*

By default, this package defines one single-connection source, called `github`, which will be disabled if you are unioning multiple connections. This means that your DAG will not include your GitHub sources, though the package will run successfully.

To properly incorporate all of your GitHub connections into your project's DAG:
1. Define each of your sources in a `.yml` file in your project. Utilize the following template for the `source`-level configurations, and, **most importantly**, copy and paste the table and column-level definitions from the package's `src_github.yml` [file](https://github.com/fivetran/dbt_github/blob/main/models/staging/src_github.yml).

```yml
# a .yml file in your root project
sources:
  - name: <name> # ex: Should match name in github_sources
    schema: <schema_name>
    database: <database_name>
    loader: fivetran
    loaded_at_field: _fivetran_synced

    freshness: # feel free to adjust to your liking
      warn_after: {count: 72, period: hour}
      error_after: {count: 168, period: hour}

    tables: # copy and paste from github/models/staging/src_github.yml - see https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/ for how to use anchors to only do so once
```

> **Note**: If there are source tables you do not have (see [Step 4](https://github.com/fivetran/dbt_github?tab=readme-ov-file#step-4-disable-models-for-non-existent-sources)), you may still include them, as long as you have set the right variables to `False`. Otherwise, you may remove them from your source definition.

2. Set the `has_defined_sources` variable (scoped to the `github` package) to `True`, like such:
```yml
# dbt_project.yml
vars:
  github:
    has_defined_sources: true
```

### Step 4: Disable models for non-existent sources
Your GitHub connection might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in GitHub or have actively excluded some tables from your syncs.

If you do not have the `TEAM`, `REPO_TEAM`, `ISSUE_ASSIGNEE`, `ISSUE_LABEL`, `LABEL`, or `REQUESTED_REVIEWER_HISTORY` tables synced and are not running the package via Fivetran Quickstart, add the following variables to your `dbt_project.yml` file:

```yml
vars:
    github__using_repo_team: false # by default this is assumed to be true. Set to false if missing TEAM or REPO_TEAM
    github__using_issue_assignee: false # by default this is assumed to be true
    github__using_issue_label: false # by default this is assumed to be true
    github__using_label: false # by default this is assumed to be true
    github__using_requested_reviewer_history: false # by default this is assumed to be true
```

*Note: This package only integrates the above variables. If you'd like to disable other models, please create an [issue](https://github.com/fivetran/dbt_github/issues) specifying which ones.*

### (Optional) Step 5: Additional configurations

<details open><summary>Expand/collapse configurations</summary>

#### Change the build schema
By default, this package builds the GitHub staging models within a schema titled (`<target_schema>` + `_github_source`) and your GitHub modeling models within a schema titled (`<target_schema>` + `_github`) in your destination. If this is not where you would like your GitHub data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    github:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_github/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    github_<default_source_table_name>_identifier: your_table_name 
```
</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_github/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_github/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
