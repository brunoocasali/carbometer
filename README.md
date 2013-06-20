
# Carbometer
Carbometer is built on the [dashing](http://shopify.github.com/dashing)
framework. See the project page for widget authoring information.

Carbometer uses [Carbometrics](https://github.com/carbonfive/carbometrics)
as the API server for retrieving data used for the dashboards.

## Setup
1. Clone and run [Carbometrics](https://github.com/carbonfive/carbometrics)
1. Set up environment variables

  1. `CARBOMETRICS_HOSTNAME`: Set this to point to the backend API. If not
      specified, then Carbometrics will default to `localhost:3000`.

  1. `TIMESHEET_HOSTNAME`: The hostname for Timesheet. By default, Timesheet
      communication is over ssl, so don't include the protocol in the hostname.

  1. `TIMESHEET_API_TOKEN`: Generate an API token from within your Timesheet
      account and set it here.

  1. `TWITTER_CONSUMER_KEY`, `TWITTER_CONSUMER_SECRET`, `TWITTER_OAUTH_KEY`
     and `TWITTER_OAUTH_SECRET`.

1. Run `dashing start` and go to `localhost:3030`.

## Deployment

### Heroku
Environment specific settings will have to be set as [Config Vars](https://devcenter.heroku.com/articles/config-vars).
Set each environment variable required (see [Required Environment Variables](#required-environment-variables)).

## Configuration

### Dashboard Rotation
Rotation of dashboards is provided by the rotation dashboard. The rotation dashboard is located at `/rotation`.

By default, Carbometer will rotate dashboards at a default interval. A URL parameter, `rotationLength`, can be
specified to override the rate of rotation. A value of `-1` will disable rotation, any other value will determine
the rotation interval in milliseconds.

The dashboards that are rotated can also be specified with the `dashboards` URL parameter. The value of `dashboards`
must be a comma separated list of valid dashboards.

### Location
Some widgets are location aware. By default `sf` is the location used to populate the widgets. To specify a different
location, provide the `location` URL parameter. For Los Angeles `location=la`.
