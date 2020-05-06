# Github 

This package models Github data from [Fivetran's connector](https://fivetran.com/docs/applications/github). It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1lx6ez7-x-s-n2JCnCi3SjG4XMmx9ysNUvaNCaWc3I_I/edit).

This package enables you to better understand your Github issues and pull requests.  The main focus is to enhance these two core objects with commonly used metrics. 

### Models

The primary outputs of this package are described below. Staging and intermediate models are used to create these output models.

**model**|**description**
-----|-----
github\_issues|Each record represents a github issue, enriched with data about it's assignees, milestones, and time comparisons.
github\_pull\_requests|Each record represents a github pull request, enriched with data about it's repository, reviewers, and durations between review requests, merges and reviews.
issues\_and\_prs\_per\_month|Each record represents a single month, enriched with metrics about PRs and issues that were created and closed during that period.


## Upcoming changes with dbt version 0.17.0

As a result of functionality being released with version 0.17.0 of dbt, there will be some upcoming changes to this package. The staging/adapter models will move into a seperate package, `github_source`, that defines the staging models and adds a source for Github data. The two packages will work together seamlessly. By default, this package will reference models in the source package, unless the config is overridden. 

There are a few benefits to this approach:
* For users who want to manage their own transformations, they can still benefit from the source definition, documentation and staging models of the source package.
* For users who have multiple sets of Github data in their warehouse, a package defining sources doesn't make sense. They will have to define their own sources and union that data together. At that point, they will still be able to make use of this package to transform their data.

When this change occurs, we will release a new version of this package.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
The [variables](https://docs.getdbt.com/docs/using-variables) needed to configure this package are as follows:

**variable**|**information**|**required**
-----|-----|-----
card|Table, model or source containing card details|Yes
issue\_assignee|Table, model or source containing issue assignee details|Yes
issue\_closed\_history|Table, model or source containing issue closed history details|Yes
issue\_comment|Table, model or source containing issue comment details|Yes
issue\_label\_history|Table, model or source containing issue label history details|Yes
issue\_label|Table, model or source containing issue label details|Yes
issue\_merged|Table, model or source containing issue merged details|Yes
issue\_project\_history|Table, model or source containing issue project history details|Yes
issue|Table, model or source containing issue details|Yes
milestone|Table, model or source containing milestone details|Yes
project|Table, model or source containing project details|Yes
pull\_request\_review|Table, model or source containing pull request review details|Yes
pull\_request|Table, model or source containing pull request details|Yes
repository|Table, model or source containing repository details|Yes
requested\_reviewer\_history|Table, model or source containing requested reviewer history details|Yes
user|Table, model or source containing user details|Yes


An example `dbt_project.yml` configuration:

```yml
# dbt_project.yml

...

models:
    github:
        vars:
            card: "{{ source('github', 'card') }}" # or "{{ ref('github_card_unioned'}) }}"
            issue_assignee: "{{ source('github', 'issue_assignee') }}"
            issue_closed_history: "{{ source('github', 'issue_closed_history') }}"
            issue_comment: "{{ source('github', 'issue_comment') }}"
            issue_label_history: "{{ source('github', 'issue_label_history') }}"
            issue_label: "{{ source('github', 'issue_label') }}"
            issue_merged: "{{ source('github', 'issue_merged') }}"
            issue_project_history: "{{ source('github', 'issue_project_history') }}"
            issue: "{{ source('github', 'issue') }}"
            milestone: "{{ source('github', 'milestone') }}"
            project: "{{ source('github', 'project') }}"
            pull_request_review: "{{ source('github', 'pull_request_review') }}"
            pull_request: "{{ source('github', 'pull_request') }}"
            repository: "{{ source('github', 'repository') }}"
            requested_reviewer_history: "{{ source('github', 'requested_reviewer_history') }}"
            user: "{{ source('github', 'user') }}"
```

### Contributions ###

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

### Resources:
- Learn more about Fivetran [here](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
