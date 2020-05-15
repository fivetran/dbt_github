# Github 

This package models Github data from [Fivetran's connector](https://fivetran.com/docs/applications/github). It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1lx6ez7-x-s-n2JCnCi3SjG4XMmx9ysNUvaNCaWc3I_I/edit).

This package enables you to better understand your Github issues and pull requests.  The main focus is to enhance these two core objects with commonly used metrics. Additonally, the metrics tables allow you to better understand your team's velocity over time.

## Models

This package contains transformation models, designed to work simultaneously with our [github source package](https://github.com/fivetran/dbt_github_source). A depenedency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

**model**|**description**
-----|-----
github\_issues|Each record represents a github issue, enriched with data about it's assignees, milestones, and time comparisons.
github\_pull\_requests|Each record represents a github pull request, enriched with data about it's repository, reviewers, and durations between review requests, merges and reviews.
github\_monthly\_metrics|Each record represents a single month, enriched with metrics about PRs and issues that were created and closed during that period.


## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default this package will run using your target database, and the "github" schema. If this is not where your github data is (perhaps your github schema is github_fivetran), please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  github_source:
    github_database: your_database_name
    github_schema: your_schema_name 
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Learn more about Fivetran [here](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
