FROM ruby:3.0.0-alpine

RUN apk update
RUN apk add build-base git nodejs yarn mysql-dev shared-mime-info

WORKDIR /app

ENV BUNDLE_PATH /bundle_cache

COPY package.json yarn.lock ./

COPY . .
