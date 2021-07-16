FROM ruby:3.0.0-alpine

RUN apk update
RUN apk add build-base git nodejs yarn mysql-dev chromium openldap-clients openssl

RUN mkdir /etc/ldap
RUN echo "TLS_REQCERT allow" > /etc/ldap/ldap.conf

WORKDIR /app

ENV BUNDLE_PATH /bundle_cache

COPY package.json yarn.lock ./

COPY . .
