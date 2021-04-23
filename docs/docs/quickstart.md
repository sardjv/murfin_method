---
id: quickstart
title: Quickstart
slug: quickstart
---

### .env file

- To get started, you need a `.env` file with secrets.
- If you use bash, you can generate one with the command:
```
sh ./script/generate_env_file.sh
```

- If not, there is an `.env.example` file included in the repo that you can use, just copy it and remove the `.example` from the filename. Make sure to change all secrets marked with **YOU_MUST_CHANGE_THIS_PASSWORD** before running in production!

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

Stop containers and remove not used ones:

```
docker-compose down --remove-orphans
```

Remove all stopped containers, networks not used by at least one container, dangling images and dangling build cache

```
docker system prune
```

## Resolving issues

On first run new file is created:

```script/first_run_complete.tmp```

In some cases deleting it may help with resolving your running issues.

## Set up Admin user

Run rails console from docker container:

```
docker-compose run --rm app bundle exec rails c
```

Add the user with respective email and password and save.

## Logging in

Auth0 or Devise can be used for login. For Auth0, you need to add your **AUTH0_CLIENT_ID** and **AUTH0_CLIENT_SECRET** to the env file in the Auth0 section.
