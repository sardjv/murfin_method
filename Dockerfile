FROM ruby:2.7.1-alpine

RUN apk update
RUN apk add build-base git nodejs yarn
RUN apk add mysql-dev

RUN mkdir /app
WORKDIR /app

ENV BUNDLE_PATH /bundle_cache

COPY package.json yarn.lock ./

COPY . .

CMD puma -C config/puma.rb
