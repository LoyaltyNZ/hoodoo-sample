# hoodo-sample

This repository contains sample code that explores hoodoo functionality. See the [wiki page](TODO) that explains the coding challenges.
## Setup

```
echo "2.7.3" > .ruby-version
bundle init
```

Add gems to Gemfile:

```
gem thin
gem rack
gem hoodoo
```

Install gems

`bundle install`


Run service

`bundle exec ruby main.rb`

# Time endpoint challenge

`
curl http://localhost:8080/1/Time/now --header 'Content-Type: application/json; charset=utf-8'`

Tests run via `bundle exec rspec spec`.

# Hello endpoint challenge

Valid input

`
curl -X POST http://localhost:8080/1/Hello --header 'Content-Type: application/json; charset=utf-8' --data '{ "first_name": "Dave", "surname": "Oram" }'`

Invalid input (missing surname):

`
curl -X POST http://localhost:8080/1/Hello --header 'Content-Type: application/json; charset=utf-8' --data '{ "first_name": "Dave" }'`
