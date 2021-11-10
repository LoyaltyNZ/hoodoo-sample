Steps

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

curl http://localhost:8080/v1/time/now --header 'Content-Type: application/json; charset=utf-8'
