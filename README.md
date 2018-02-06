# tech404 inviter

The application behind the [tech404 automatic invitation system](https://tech404.github.io)

## Usage

### POST /invitations

To enqueue an invitation request:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"andy@example.com\"}" \
  http://localhost:3000/invitations
```

The route is meant to be used by a JavaScript client. Browsers will require CORS to be setup correctly: you can whitelist CORS origins in `config/application.rb`. Other applications (e.g., `curl`) do not require CORS.

### GET /sidekiq

Pointing your web browser at the /sidekiq endpoint will give you access to Sidekiq's built-in dashboard. User the username and password you set in the environmental variables below.

## Configuration

Configuration items are stored in environment variables.

* SLACK_SUBDOMAIN: e.g., tech404 for tech404.slack.com
* SLACK_TOKEN: an API token for an administrator of the organization ([more details](#slack_token))
* SIDEKIQ_USERNAME: username for the sidekiq administration area
* SIDEKIQ_PASSWORD: password for the sidekiq administration area
* REDIS_PROVIDER: pointer to the configuration variable where a Redis URL is stored ([more details](#redis_provider))

### REDIS\_PROVIDER

The `REDIS_PROVIDER` configuration variable should point to the configuration variable where the Redis URL is set.

For example, to use Redis Cloud on Heroku:

```
heroku addons:add rediscloud
heroku config:set REDIS_PROVIDER=REDISCLOUD_URL
```

### SLACK\_TOKEN

A normal Slack API token _will not work correctly_. To retrieve an API token that can be used for invitations, navigate to the invitation page on the Slack web interface (as if you were going to manually invite someone), view the source of the page, and extract the `api_token`. Use this value as `SLACK_TOKEN`.

_Do not logout of the session where the token was generated._ If the token becomes invalid, requests will fail and queue up. To resolve the issue, generate a new token. Sidekiq will eventually re-run the jobs.

## Development

### Prerequisites

* PostgreSQL: `brew install postgresql`
* Redis: `brew install redis`

## Deployment

Deployed on Heroku. Ask @alindeman for access. In production, we run a puma process in the same dyno as a sidekiq worker. It's a hack to keep it free.
