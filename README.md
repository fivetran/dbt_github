[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 
![dbt-core](https://img.shields.io/badge/dbt_core-version_>=1.0.0_<2.0.0-orange.svg)

# GitHub dbt Package ([Docs](https://dbt-github.netlify.app/))

## 📣 What does this dbt package do?
This pre-built, open-source package builds on the [dbt_GitHub_source dbt package](https://github.com/fivetran/dbt_github_source). It applies transformations that enhance your GitHub issues and pull requests with common metrics so you can better understand them. Additionally, the metrics tables show your team's velocity over time. These metrics are available on a daily, weekly, monthly, and quarterly level. 

This dbt package runs the following staging models in your destination:

| **model**                  | **description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [github__issues](https://dbt-github.netlify.app/#!/model/model.github.github__issues)             | Each record represents a GitHub issue, enriched with data about its assignees, milestones, and time comparisons.                                             |
| [github__pull_requests](https://dbt-github.netlify.app/#!/model/model.github.github__pull_requests)     | Each record represents a GitHub pull request, enriched with data about its repository and reviewers, as well as the durations between review requests, merges, and reviews. |
| [github__daily_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__daily_metrics)     | Each record represents a single day, enriched with metrics about PRs and issues that were created and closed that day.                              |
| [github__weekly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__weekly_metrics)    | Each record represents a single week, enriched with metrics about the PRs and issues that were created and closed that week.                             |
| [github__monthly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__monthly_metrics)   | Each record represents a single month, enriched with metrics about PRs and issues that were created and closed that month.                            |
| [github__quarterly_metrics](https://dbt-github.netlify.app/#!/model/model.github.github__quarterly_metrics) | Each record represents a single quarter, enriched with metrics about PRs and issues that were created and closed that quarter.                          |

## 🤔 Why should I use this dbt package?
This package is designed for users who want to use pre-built, analysis-ready models to fuel their reporting needs. The package creates reporting tables that you link directly to your BI tool for quick time to value with your GitHub data.

This package models the data so that it can effectively answer most of your business questions. However, it will never answer _all_ of your questions. If this package doesn't quite fit your reporting needs, you can still reference the models from this package and apply your own additional custom transformations. If you think that this package should include additional models and believe other users will benefit, please refer to the [Contributions]() section to learn how to contribute to the open-source package.

## 🎯 How do I use the dbt package?
To install this package and leverage the pre-built models, do the following:
### Step 1: Requirements 
#### Connector
Have the Fivetran GitHub connector syncing data into your warehouse. 
#### Database support
This package has been tested on BigQuery, Snowflake and Redshift. Ensure you are using one of these supported databases.

#### dbt Version
This dbt package requires you have a functional dbt project that utilizes a dbt version within the respective range `>=1.0.0, <2.0.0`.
  - If you do not have dbt installed, I recommend you refer to the [dbt setup guide]() for details on how to get your first dbt project set up.

### Step 2: Install the Package
1. In your dbt project, open your `packages.yml` file.
2. Add the following GitHub package version:

```yaml
packages:
  - package: fivetran/github
    version: [">=0.5.0", "<0.6.0"]
```
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

### Step 3: Configure Your Variables
#### 3a. Update Schema Variables

By default, this package runs using your target database and the `github` schema. 

- If your GitHub data is in the `github` schema, proceed to the next step.
- If your GitHub data is in a different schema (for example, `Github_fivetran`), add the following configuration to the `dbt_project.yml` file in your dbt project:

  ```yml
  # dbt_project.yml

  ...
  config-version: 2

  vars:
    github_source:
      github_database: your_database_name
      github_schema: your_schema_name 
  ```

#### 3b. Disable Model Variables
Your GitHub connector may not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in GitHub or have chosen to exclude those tables from your syncs.

If you do not have the `REPO_TEAM` table synced, add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml
config-version: 2

vars:
    github__using_repo_team: false # by default this is assumed to be true
```

> NOTE: This package only integrates the variable above. If you'd like to disable other models, please create an [issue](https://github.com/fivetran/dbt_github_source/issues) specifying which models you want to disable.

### (Optional) Step 4: Change the Build Schema

By default, this package builds the GitHub staging models within a schema named (<target_schema> + `_stg_github`) and your GitHub transform models within a schema titled (<target_schema> + `_github`) in your target database. If this is not where you would like us to write your GitHub staging data, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    github_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    github:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

### Step 5: Finish Setup
You have successfully set up your dbt project to run the dbt package models! You can now execute `dbt run` and `dbt test` to see the models materialize in your destination and execute the data integrity tests applied within the package.

### (Optional) Step 6: Orchestrate your package models with Fivetran
Fivetran offers the ability for you to orchestrate your dbt project within the Fivetran dashboard. Learn how to orchestrate dbt models in your dashboard in the [Transformations for dbt Core documentation](https://fivetran.com/docs/transformations/dbt).

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on these packages, see the [dbt hub](https://hub.getdbt.com/).

>IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them to ensure that there are no package version conflicts.

```
packages:
  - package: fivetran/github_source
    version: [">=0.5.0", "<0.6.0"]
  - package: fivetran/fivetran_utils
    version: [">=0.3.0", "<0.4.0"]
  - package: dbt-labs/dbt_utils
    version: [">=0.8.0", "<0.9.0"]
```

## 🙌 Contributions and Maintenance
### Package Maintenance
The Fivetran team **only** maintains the latest version of the package. We highly recommend you stay up-to-date with the [latest version](https://hub.getdbt.com/fivetran/github_source/latest/) of the package. See the [CHANGELOG file](/CHANGELOG.md) and release notes to read about changes across versions.

### Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Please see the [CONTRIBUTING.md](/CONTRIBUTING.md) doc to learn how to effectively contribute to this open source project!

## 🏪 Resources and Feedback
- If you have questions or want to reach out for help, please refer to [this package's GitHub Issue menu](https://github.com/fivetran/dbt_github_source/issues/new/choose) to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or request a new dbt package, feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
