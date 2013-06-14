
# Carbometer
Carbometer is based on the [dashing](http://shopify.github.com/dashing)
framework. See their website for widget authoring information. In
addition [Carbometrics](https://github.com/carbonfive/carbometrics) is
used as an API server for retrieving data used for the dashboards.

## Setup
1. Clone and run
   [Carbometrics](https://github.com/carbonfive/carbometrics)
2. Clone and run Carbometer

### Required Environment Variables
1. `CARBOMETRICS_HOSTNAME`
    Host name for Carbometrics

2. `TIMESHEET_HOSTNAME`
   Host name for Timesheet. By default, Timesheet communication is over ssl. Therefore do not include the protocol in the Hostname (i.e. https://).

3. `TIMESHEET_API_TOKEN`
   API token for Timesheet

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
