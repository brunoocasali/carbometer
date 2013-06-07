
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

## Deployment

### Heroku
Environment specific settings will have to be set as [Config Vars](https://devcenter.heroku.com/articles/config-vars).
Set each environment variable required (see [Required Environment Variables](#required-environment-variables)).

## Configuration

### Dashboard Rotation
By default, Carbometer will rotate dashboards and a default interval. A URL parameter, `rotationLength`, can be
specified to override the rate of rotation. A value of `-1` will disable rotation, any other value will determine
the rotation interval in milliseconds.

### Location
Some widgets are location aware. By default `sf` is the location used to populate the widgets. To specify a different
location, provide the `location` URL parameter. For Los Angeles `location=la`.
