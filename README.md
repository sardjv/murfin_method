# Murfin+: a Ruby on Rails app for building NHS data dashboards

# Full documentation can be found here: [https://sardjv.github.io/murfin_method](https://sardjv.github.io/murfin_method)

[![CircleCI Build Status](https://circleci.com/gh/sardjv/murfin_method.svg?style=shield)](https://circleci.com/gh/sardjv/murfin_method)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/sardjv/murfin_method/blob/master/LICENSE)

## .env file

To get started, you need a `.env` file with secrets. If you use bash, you can generate one with the command `sh ./script/generate_env_file.sh`. If not, there is an `.env.example` file included in the repo that you can use, just remove the `.example` from the filename. Make sure to change all secrets marked with YOU_MUST_CHANGE_THIS_PASSWORD before running in production!

You also need to set AUTH_METHOD to either _form_ or _oauth2_ in the _.env_ file.

## Booting up

If you have Docker on your machine:

### Setup

```
cp docker-compose.override.yml.sample docker-compose.override.yml
docker-compose build
```

### Start
```
docker-compose up
```

It can then be accessed at [http://localhost:3000/](http://localhost:3000/)

### Stop

Stop containers but do not remove them:

```
docker-compose stop
```

Stop containers and remove them:

```
docker-compose down --remove-orphans
```

Remove all stopped containers, networks not used by at least one container, dangling images and dangling build cache

```
docker system prune
```

## Logging in

Auth0 or Devise can be used for login. For Auth0, you need to add your client ID and secret to the env file in the Auth0 section.

## Caching

You can view keys in the Redis cache from the console with:

```
Redis.new(url: "redis://redis:#{ENV['REDIS_PORT']}/0", password: ENV['REDIS_PASSWORD'], namespace: ENV['REDIS_CACHE_NAMESPACE']).keys('*')
```

or

```
Rails.cache.redis.keys('*')
```

## Deployment without Docker

If you can run [Docker](https://en.wikipedia.org/wiki/Docker_(software)), that is the quickest way to get started. If Docker install is not possible, the Dockerfile, docker-compose.yml and Gemfile files included in the repository can be used as a guide for dependencies.

Core dependencies:

- Ruby [https://github.com/ruby/ruby](https://github.com/ruby/ruby)
- Rails [https://github.com/rails/rails](https://github.com/rails/rails)
- Redis [https://redis.io/](https://redis.io/)
- Sidekiq [https://github.com/mperham/sidekiq](https://github.com/mperham/sidekiq)
- MySQL
- Multiple supporting gems as listed in the Gemfile, Bundler (included in Ruby) should take care of installing these.

### API

The auto-generated API documentation can be viewed at [http://localhost:3000/api_docs](http://localhost:3000/api_docs).

The Swagger docs are generated from the RSpec tests in `spec/api` To rebuild the swagger docs:

```
docker-compose run --rm app bundle exec rails rswag
```

_Note: --rm option removes container after task ended._

## Specs

To run Rubocop, and listen for file changes:

```
docker-compose run app bundle exec guard
```

Just press enter to run the whole test suite straight away.

To view and interact with a visible Chrome browser in feature tests, uncomment this line in `rails_helper.rb`:

```
c.javascript_driver = :chrome_visible
```

This exposes a [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) server on port `5900`. You can access it on MacOS with:

```
open vnc://0.0.0.0:5900
```

The password is 'secret'. Run a feature spec with that window open and you should see the test running.

_Note: feature specs should be run from app shell, so connect first:_

```
docker exec -it murfin_method_app_1 sh
```

## Code Coverage

After running the test suite, open the coverage/index.html file in a web browser to check what code is covered by the tests.

```
open coverage/index.html
```

## Debugging

To access a 'binding.pry' debugging point, run with:

```
docker-compose run --service-ports app
```

## Model Annotation

To annotate rails models with schema run

```
docker-compose run --rm app bundle exec annotate --models
```

## Accessing the database console

To access the MySQL database console:

```
docker-compose exec db bash
mysql -u root -p
(enter root password)
show databases;
use murfin_method_development;
SELECT * FROM users;
```

## Profiling performance

To print a report of time, memory and database calls:

```
  require 'performance'
  Performance.test { object.method }
```

## Resolving issues

On first run new file is created:

```script/first_run_complete.tmp```

In some cases deleting it may help with resolving your running issues.
