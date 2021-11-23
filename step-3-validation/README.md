# Step 2: The basics

This repository contains sample code that explores basic hoodoo functionality. See [Step 3 on the wiki page](https://loyaltynz.atlassian.net/wiki/spaces/FT/pages/1630601431/Hoodoo+sample+app+challenge#Step-3.-Validation) that explains this challenge - using Hoodoo presenters.


## Setup

Install gems

`bundle install`

Run service

`bundle exec ruby main.rb`


# Hello endpoint challenge

Valid input

```
curl -X POST http://localhost:8080/1/Hello --header 'Content-Type: application/json; charset=utf-8' --data '{ "first_name": "Dave", "surname": "Oram" }'
```

Invalid input (missing surname):

```
curl -X POST http://localhost:8080/1/Hello --header 'Content-Type: application/json; charset=utf-8' --data '{ "first_name": "Dave" }'
```

Tests run via `bundle exec rspec spec`.