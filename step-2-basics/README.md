# Step 2: The basics

This repository contains sample code that explores basic hoodoo functionality. See [Step 2 on the wiki page](https://loyaltynz.atlassian.net/wiki/spaces/FT/pages/1630601431/Hoodoo+sample+app+challenge#Step-2.-Build-a-Hoodoo-service-that-returns-the-current-time) that explains the coding challenges.

## Setup

Install gems

`bundle install`

Run service

`bundle exec ruby main.rb`

# Time endpoint challenge

```
curl http://localhost:8080/1/Time/now --header 'Content-Type: application/json; charset=utf-8'
```

Tests run via `bundle exec rspec spec`.

