# ATLDevs

The application behind the [tech404 automatic invitation system](http://tech404.io)

## Prerequisites

* PostgreSQL: `brew install postgresql`
* Redis: `brew install redis`

## Required Configuration

Configuration items are stored in environment variables.

* SLACK_SUBDOMAIN: e.g., atldevs for atldevs.slack.com
* SLACK_TOKEN: an API token for an administrator of the organization
* SIDEKIQ_USERNAME: username for the sidekiq administration area
* SIDEKIQ_PASSWORD: password for the sidekiq administration area

## Deployment

Deployed on Heroku. Ask @alindeman for access. In production, we run a puma process in the same dyno as a sidekiq worker. It's a hack to keep it free.
