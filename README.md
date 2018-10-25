
<img src="./logo.svg" width=350>

- [solidus.io](http://solidus.io/)
- [Documentation](https://guides.solidus.io)
- [Join our Slack](http://slack.solidus.io/) ([solidusio.slack.com](http://solidusio.slack.com))
- [solidus-security](https://groups.google.com/forum/#!forum/solidus-security) mailing list

## devise_token_auth fork summary

Background story tl;dr: I wanted to use `solidus_api` along with provided admin panel (`solidus_backend`), but the default api authentication mechanism
did not satisfy my security and usage needs at all. At first, I only wanted to fork the `solidus_api` gem and integrate it with [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth),
but it turned out that the whole solidus project heavily relies on this default `spree_api_key` thing - so here it is, a `solidus` fork, extensively revised to be fully compliant with `devise_token_auth`,
replacing the `spree_api_key` mechanism also in stuff like `solidus_backend`. The test suite is fully passing; I have also upgraded it a little to test stuff (like authentication) that it used to just stub previously.

There are so many changes that it can't simply be merged to the upstream repository - people use that `spree_api_key` in their own integrations, so this fork is usable mostly when you're starting from scratch
and want to use solidus with devise_token_auth or you want to use the solidus_api for the first time, or if you want to refactor your existing `solidus_api` app to become more secure.

As of 24.10.2018 the upstream repository is merged, but if you need some latest solidus features and nobody updates this repo from the upstream, feel free to do it yourself - it shouldn't take much more
than just resolving some git conflicts, bumping the version and submitting a pull request here.

## So how do I use this with `devise_token_auth`?

To add solidus_devise_token_auth, begin with a Rails 5 application and a database configured and created. Add the following to your Gemfile:

```ruby
gem 'solidus_devise_token_auth'
gem 'solidus_auth_devise_devise_token_auth'
```

Because of the gem name being different, you have to include this in your `config/application.rb` (depending on what you want to use):

```ruby
require 'solidus_core'
require 'solidus_api'
require 'solidus_backend'
require 'solidus_frontend'
require 'solidus_sample'
```

Then basically just follow the original solidus guides, watching out for api authentication (described [here](https://github.com/skycocker/solidus/blob/master/guides/source/developers/api/overview.html.md)).

## How do I use just specific components?

Every piece is rebuilt and available on rubygems:

```ruby
gem 'solidus_api_devise_token_auth'
gem 'solidus_frontend_devise_token_auth'
gem 'solidus_backend_devise_token_auth'
gem 'solidus_core_devise_token_auth'
gem 'solidus_sample_devise_token_auth'
```


## Solidus summary

Solidus is a complete open source ecommerce solution built with Ruby on Rails.
It is a fork of [Spree](https://spreecommerce.org).

See the [Solidus class documentation](http://docs.solidus.io) and the [Solidus
Guides](https://guides.solidus.io) for information about the functionality that
Solidus provides.

Solidus consists of several gems. When you require the `solidus` gem in your
`Gemfile`, Bundler will install all of the gems maintained in this repository:

- [`solidus_api`](https://github.com/solidusio/solidus/tree/master/api) (RESTful API)
- [`solidus_frontend`](https://github.com/solidusio/solidus/tree/master/frontend) (Cart and storefront)
- [`solidus_backend`](https://github.com/solidusio/solidus/tree/master/backend) (Admin area)
- [`solidus_core`](https://github.com/solidusio/solidus/tree/master/core) (Essential models, mailers, and classes)
- [`solidus_sample`](https://github.com/solidusio/solidus/tree/master/sample) (Sample data)

All of the gems are designed to work together to provide a fully functional
ecommerce platform. However, you may only want to use the
[`solidus_core`](https://github.com/solidusio/solidus/tree/master/core) gem
combine it with your own custom frontend, admin interface, and API.

[![Circle CI](https://circleci.com/gh/solidusio/solidus/tree/master.svg?style=shield)](https://circleci.com/gh/solidusio/solidus/tree/master)
[![Gem](https://img.shields.io/gem/v/solidus.svg)](https://rubygems.org/gems/solidus)
[![License](http://img.shields.io/badge/license-BSD-yellowgreen.svg)](LICENSE.md)
[![Slack](http://slack.solidus.io/badge.svg)](http://slack.solidus.io)

## Demo

Try out Solidus with one-click on Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/solidusio/solidus)

## Getting started

Begin by making sure you have
[Imagemagick](http://imagemagick.org/script/download.php) installed, which is
required for Paperclip. (You can install it using [Homebrew](https://brew.sh) if
you're on a Mac.)

To add solidus, begin with a Rails 5 application and a database configured and
created. Add the following to your Gemfile.

```ruby
gem 'solidus'
gem 'solidus_auth_devise'
```

Run the `bundle` command to install.

After installing gems, you'll have to run the generators to create necessary
configuration files and migrations.

```bash
bundle exec rails g spree:install
bundle exec rails g solidus:auth:install
bundle exec rake railties:install:migrations
```

Run migrations to create the new models in the database.

```bash
bundle exec rake db:migrate
```

Finally start the rails server

```bash
bundle exec rails s
```

The [`solidus_frontend`](https://github.com/solidusio/solidus/tree/master/frontend) storefront will be accessible at [http://localhost:3000/](http://localhost:3000/)
and the admin can be found at [http://localhost:3000/admin/](http://localhost:3000/admin/).

### Default Username/Password

As part of running the above installation steps, you will be asked to set an admin email/password combination. The default values are `admin@example.com` and `test123`, respectively.

### Questions?

The best way to ask questions is via the [#support channel on the Solidus Slack](https://solidusio.slack.com/messages/support/details/).

Installation options
--------------------

Instead of a stable build, if you want to use the bleeding edge version of
Solidus, use this line:

```ruby
gem 'solidus', github: 'solidusio/solidus'
```

**Note: The master branch is not guaranteed to ever be in a fully functioning
state. It is unwise to use this branch in a production system you care deeply
about.**

By default, the installation generator (`rails g spree:install`) will run
migrations as well as adding seed and sample data. This can be disabled using

```bash
rails g spree:install --migrate=false --sample=false --seed=false
```

You can always perform any of these steps later by using these commands.

```bash
bundle exec rake railties:install:migrations
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake spree_sample:load
```

There are also options and rake tasks provided by
[solidus\_auth\_devise](https://github.com/solidusio/solidus_auth_devise).

Performance
-----------

You may notice that your Solidus store runs slowly in development mode. This
can be because in development each CSS and JavaScript is loaded as a separate
include. This can be disabled by adding the following to
`config/environments/development.rb`.

```ruby
config.assets.debug = false
```

### Turbolinks

To gain some extra speed you may enable Turbolinks inside of Solidus admin.

Add `gem 'turbolinks', '~> 5.0.0'` into your `Gemfile` (if not already present) and append these lines to `vendor/assets/spree/backend/all.js`:

```js
//= require turbolinks
//= require backend/app/assets/javascripts/spree/backend/turbolinks-integration.js
```

**CAUTION** Please be aware that Turbolinks can break extensions and/or customizations to the Solidus admin.
Use at own risk.

Developing Solidus
------------------

* Clone the Git repo

    ```bash
    git clone git://github.com/solidusio/solidus.git
    cd solidus
    ```

* Install the gem dependencies

    ```bash
    bundle install
    ```

### Sandbox

Solidus is meant to be run within the context of Rails application. You can
easily create a sandbox application inside of your cloned source directory for
testing purposes.

This sandbox includes solidus\_auth\_devise and generates with seed and sample
data already loaded.

* Create the sandbox application (`DB=mysql` or `DB=postgresql` can be specified
  to override the default sqlite)

  ```bash
  bundle exec rake sandbox
  ```

* Start the server

    ```bash
    cd sandbox
    rails server
    ```

### Tests

Solidus uses [RSpec](http://rspec.info) for tests. Refer to its documentation for
more information about the testing library.

#### CircleCI

We use CircleCI to run the tests for Solidus as well as all incoming pull
requests. All pull requests must pass to be merged.

You can see the build statuses at
[https://circleci.com/gh/solidusio/solidus](https://circleci.com/gh/solidusio/solidus).

#### Run all tests

[ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/home) is
required to run the frontend and backend test suites.

To execute all of the test specs, run the `build.sh` script at the root of the Solidus project:

```bash
bash build.sh
```

The `build.sh` script runs using PostgreSQL by default, but it can be overridden by setting the DB environment variable to `DB=sqlite` or `DB=mysql`. For example:

```bash
DB=mysql bash build.sh
```

#### Run an individual test suite

Each gem contains its own series of tests. To run the tests for the core project:

```bash
cd core
bundle exec rspec
```

By default, `rspec` runs the tests for SQLite 3. If you would like to run specs
against another database you may specify the database in the command:

```bash
DB=postgresql bundle exec rspec
```

#### Code coverage reports

If you want to run the [SimpleCov](https://github.com/colszowka/simplecov) code
coverage report:

```bash
COVERAGE=true bundle exec rspec
```

### Extensions

In addition to core functionality provided in Solidus, there are a number of
ways to add features to your store that are not (or not yet) part of the core
project.

A list can be found at [extensions.solidus.io](http://extensions.solidus.io/).

If you want to write an extension for Solidus, you can use the
[solidus_cmd](https://www.github.com/solidusio/solidus_cmd.git) gem.

Contributing
------------

Solidus is an open source project and we encourage contributions. Please read
[CONTRIBUTING.md](CONTRIBUTING.md) before contributing.
