FROM ruby:3.0.0-alpine

#ENV GROVER_NO_SANDBOX true
#ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
#ENV CHROMIUM_PATH /usr/bin/chromium-browser

RUN apk update
RUN apk add build-base git nodejs yarn mysql-dev chromium

WORKDIR /app

ENV BUNDLE_PATH /bundle_cache

COPY package.json yarn.lock ./

COPY . .
