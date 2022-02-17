[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# GitHub ([Docs](https://dbt-github.netlify.app/))

This package models GitHub data from [Fivetran's connector](https://fivetran.com/docs/applications/github). It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1lx6ez7-x-s-n2JCnCi3SjG4XMmx9ysNUvaNCaWc3I_I/edit).

This package enables you to better understand your GitHub issues and pull requests.  Its main focus is to enhance these two core objects with commonly used metrics. Additionally, the metrics tables let you better understand your team's velocity over time.  These metrics are available on a daily, weekly, monthly and quarterly level.

## Models

This package contains transformation models, designed to work simultaneously with our [GitHub source package](https://github.com/fivetran/dbt_github_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                  | **description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [github__issues](https://github.com/fivetran/dbt_github/blob/master/models/github__issues.sql)             | Each record represents a GitHub issue, enriched with data about its assignees, milestones, and time comparisons.                                             |
| [github__pull_requests](https://github.com/fivetran/dbt_github/blob/master/models/github__pull_requests.sql)     | Each record represents a GitHub pull request, enriched with data about its repository, reviewers, and durations between review requests, merges and reviews. |
| [github__daily_metrics](https://github.com/fivetran/dbt_github/blob/master/models/github__daily_metrics.sql)     | Each record represents a single day, enriched with metrics about PRs and issues that were created and closed during that period.                              |
| [github__weekly_metrics](https://github.com/fivetran/dbt_github/blob/master/models/github__weekly_metrics.sql)    | Each record represents a single week, enriched with metrics about PRs and issues that were created and closed during that period.                             |
| [github__monthly_metrics](https://github.com/fivetran/dbt_github/blob/master/models/github__monthly_metrics.sql)   | Each record represents a single month, enriched with metrics about PRs and issues that were created and closed during that period.                            |
| [github__quarterly_metrics](https://github.com/fivetran/dbt_github/blob/master/models/github__quarterly_metrics.sql) | Each record represents a single quarter, enriched with metrics about PRs and issues that were created and closed during that period.                          |


## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/github
    version: [">=0.5.0", "<0.6.0"]
```

## Configuration
By default, this package will look for your GitHub data in the `github` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your GitHub data is (perhaps your GitHub schema is `github_fivetran`), add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  github_source:
    github_database: your_database_name
    github_schema: your_schema_name 
```

### Disabling Models
Your Github connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Github or have actively excluded some tables from your syncs.

If you do not have the `REPO_TEAM` table synced, add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml
config-version: 2

vars:
    github__using_repo_team: false # by default this is assumed to be true
```

*Note: This package only integrates the above variable. If you'd like to disable other models, please create an [issue](https://github.com/fivetran/dbt_github/issues) specifying which ones.*

## Database support
This package has been tested on BigQuery, Snowflake and Redshift.

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn more about Fivetran [in the Fivetran docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
