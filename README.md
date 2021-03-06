[![Build Status](https://travis-ci.org/DFE-Digital/govuk-rails-boilerplate.svg?branch=master)](https://travis-ci.com/DFE-Digital/govuk-rails-boilerplate)

# Academy Transfers Frontend

This is a proof of concept Academy Transfers service. Built on the [govuk-rails-boilerplate](https://github.com/DFE-Digital/govuk-rails-boilerplate) template. This repository is the frontend component, it is designed to work with the [Academy Transfers API](https://github.com/DFE-Digital/academy-transfers-api).

This is not part of live or production service. And it should not be used as one.

More details on the how to use a boilerplate below.


# GOV.UK Rails Boilerplate

## Prerequisites

- Ruby 2.7.1
- PostgreSQL
- NodeJS 12.13.x
- Yarn 1.12.x

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bin/rails db:setup` to set up the database development and test schemas, and seed with test data
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Whats included in this boilerplate?

- Rails 6.0 with Webpacker
- [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
- RSpec
- Dotenv (managing environment variables)
- Travis with Heroku deployment

## Running specs, linter(without auto correct) and annotate models and serializers
```
bundle exec rake
```

## Running specs
```
bundle exec rspec
```

## Linting

It's best to lint just your app directories and not those belonging to the framework, e.g.

```bash
bundle exec rubocop app config db lib spec Gemfile --format clang -a

or

bundle exec scss-lint app/webpacker/styles
```

## Configuration

Custom credentials are configured in config/application.rb and are accessed within code via
[Rails.configuration.x](https://guides.rubyonrails.org/configuring.html#custom-configuration)


In development, [Rails Credentials](https://guides.rubyonrails.org/security.html#custom-credentials) are used to store
secret credentials.

Credentials can also be defined via environment variables (see config/application.rb) which is the intention for
production environments. Credentials defined via environment credential take precidence.

## Deploying on GOV.UK PaaS

### Prerequisites

- Your department, agency or team has a GOV.UK PaaS account
- You have a personal account granted by your organisation manager
- You have downloaded and installed the [Cloud Foundry CLI](https://github.com/cloudfoundry/cli#downloads) for your platform

### Deploy

1. Run `cf login -a api.london.cloud.service.gov.uk -u USERNAME`, `USERNAME` is your personal GOV.UK PaaS account email address
2. Run `bundle package --all` to vendor ruby dependencies
3. Run `yarn` to vendor node dependencies
4. Run `bundle exec rails webpacker:compile` to compile assets
5. Run `cf push` to push the app to Cloud Foundry Application Runtime

Check the file `manifest.yml` for customisation of name (you may need to change it as there could be a conflict on that name), buildpacks and eventual services (PostgreSQL needs to be [set up](https://docs.cloud.service.gov.uk/deploying_services/postgresql/)).

The app should be available at https://govuk-rails-boilerplate.london.cloudapps.digital
