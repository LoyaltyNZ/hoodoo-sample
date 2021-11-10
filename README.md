# hoodo-sample

## Setup

```
echo "2.7.3" > .ruby-version
bundle init
``

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

# Time

`
curl http://localhost:8080/1/Time/now --header 'Content-Type: application/json; charset=utf-8'`

# Hello

`
curl -X POST http://localhost:8080/1/Hello --header 'Content-Type: application/json; charset=utf-8' --data '{ "first_name": "Dave", "surname": "Oram" }'`

Invalid:

`
curl -X POST http://localhost:8080/1/Hello --header 'Content-Type: application/json; charset=utf-8' --data '{ "first_name": "Dave" }'`
