---
id: development
title: Development
---

## .env file

To get started, you need a `.env` file with secrets. A script is provided to generate this file with new secrets:

```
sh script/generate_env_file.sh
```

If the script succeeds, it will print ".env file generation complete."

## Development mode

To use development mode, activate the docker-compose override file:

```
cp docker-compose.override.yml.sample docker-compose.override.yml
docker-compose build
```

## Booting up

If you have Docker on your machine, run:

```
docker-compose up
```

It can then be accessed at [http://localhost:3000/](http://localhost:3000/)

## API Documentation

The Swagger docs are generated from the RSpec tests in `spec/controllers/api` To rebuild the swagger docs:

```
docker-compose run api bundle exec rails rswag
```

## Licenses

You can check the licenses of unaccepted dependencies using:

```
bundle exec license_finder
```

To add accepted licenses:

```
bundle exec license_finder permitted_licenses add MIT
```

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
docker-compose run --service-ports api
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

## Stop

Stop containers but do not remove them:

```
docker-compose stop
```

Stop containers and remove them:

```
docker-compose down --remove-orphans
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


## Caching

You can view keys in the Redis cache from the console with:

```
Redis.new(url: "redis://redis:#{ENV['REDIS_PORT']}/0", password: ENV['REDIS_PASSWORD'], namespace: ENV['REDIS_CACHE_NAMESPACE']).keys('*')
```

or

```
Rails.cache.redis.keys('*')
```

## Documentation

The documentation can be found in the `/docs` directory. When Docker is running the documentation site
is served locally at [http://localhost:3002/murfin_method](http://localhost:3002/murfin_method). Any changes made
in the `/docs` directory will be immediately visible.

We also serve the documentation online at [https://sardjv.github.io/murfin_method/](https://sardjv.github.io/murfin_method/).

To deploy changes to this site:

```
cd docs # Very important! The following commands will not work at the project's root directory.
yarn install # Only the first time.
GIT_USER=<Your GitHub username> USE_SSH=true yarn deploy
```

It may take a few minutes to update.
