# tech404 inviter

The application behind the [tech404 automatic invitation system](http://tech404.io)

## Usage

### POST /invitations

To enqueue an invitation request:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"andy@example.com\"}" \
  http://localhost:3000/invitations
```

The route is meant to be used by a JavaScript client. You can whitelist CORS origins in `config/application.rb`.

NOTE: If you use a non-CORS complient browser (curl, for example) then whitelisting is ignored and it can be accessed from anywhere unless you
setup HTTP Basic Auth.

### /sidekiq

Pointing your web browser at the /sidekiq endpoint will give you access to Sidekiq's built-in dashboard. User the username and password you set in
the environmental variables below.

## Development

### Prerequisites

* PostgreSQL: `brew install postgresql`
* Redis: `brew install redis`

If being deployed to Heroku you need to setup a redis add-on of some sort. For example:

* `heroku addons:add rediscloud`
* `heroku config:set REDIS_PROVIDER=REDISCLOUD_URL`

### Required Configuration

Configuration items are stored in environment variables.

* SLACK_SUBDOMAIN: e.g., tech404 for tech404.slack.com
* SLACK_TOKEN: an API token for an administrator of the organization
* SIDEKIQ_USERNAME: username for the sidekiq administration area
* SIDEKIQ_PASSWORD: password for the sidekiq administration area
* BASIC_HTTP_USERNAME: username for the /invitations endpoint
* BASIC_HTTP_PASSWORD: password for the /invitations endpoint

NOTE: If BASIC_HTTP_USERNAME or BASIC_HTTP_PASSWORD are unset then no Basic Auth will take place.

## SLACK_TOKEN

This part is a bit dodgy. What you need to do is point your web browser at the invitation page (as if you were going to manually invite someone)
and then search the page source for 'api_token'. This is the token you want to use.

NOTE: Whichever session you use to generate the token don't explicitly logout of that session. If the token becomes invalid requests will just queue up.
You will need to go to the invite page again and fetch the new token and set that. Requests will then continue to process. (No requests will be lost)

## Deployment

Deployed on Heroku. Ask @alindeman for access. In production, we run a puma process in the same dyno as a sidekiq worker. It's a hack to keep it free.
