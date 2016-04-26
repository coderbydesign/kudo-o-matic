# Kudo-o-Matic™

[![Travis Build Status](https://img.shields.io/travis/kabisa/kudo-o-matic.svg?style=flat-square)](https://travis-ci.org/kabisa/kudo-o-matic.svg?branch=master) [![GitHub release](https://img.shields.io/github/release/kabisa/kudo-o-matic.svg?style=flat-square)](https://github.com/kabisa/kudo-o-matic/releases) [![GitHub license](https://img.shields.io/github/license/kabisa/kudo-o-matic.svg?style=flat-square)](https://github.com/kabisa/kudo-o-matic/blob/master/LICENSE.md)

Kudo-o-Matic is a web service for tracking Kudo achievements in a team. 

This is very much a work-in-progress. Things will break. More later.

## Requirements

* Ruby > 2.0
* Bundler (ruby gem)
* Postgres

## To start your Kudo-o-Matic app locally:

  * Install bundler `gem install bundler`
  * Install dependencies with `bundle install`
  * Add default db settings `cp config/database.yml.example config/database.yml` (change if needed)
  * Create and migrate your database with `rake db:setup`
  * Start Rails with `rails s`

Now you can view your kudos [`localhost:3000`](http://localhost:3000) from your browser.


## Notes

 * To secure your installation, specify a `HTTP_AUTH` env variable in the format `username:password` to enable http basic authentication.
