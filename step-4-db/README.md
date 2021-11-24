# Step 4: Database

This repository contains sample code for a Hoodoo service with a back end Postgres database. See [Step 4 on the wiki page](https://loyaltynz.atlassian.net/wiki/spaces/FT/pages/1630601431/Hoodoo+sample+app+challenge#Step-4.-Database-access) that explains this challenge.


## Setup

### Ruby

Install gems

```
cd service_person
bundle install
```


### JQ

`brew install jq`

### Postgres

Run postgres in Docker.

Setup a directory to hold the data:

```
mkdir ${HOME}/docker-postgres-data/
```

Run postgres in a separate terminal

```
docker run --name dev-postgres -v ${HOME}/docker-postgres-data/:/var/lib/postgresql/data -e POSTGRES_PASSWORD='password' --rm -p 5432:5432 --network=bridge postgres:13
```

Check postgres access, using your favourite postgres client application using the connection URL: `postgresql://postgres:password@localhost`, eg: using `psql` should look like this:

```
$ psql postgresql://postgres:password@localhost
psql (14.0, server 13.4 (Debian 13.4-1.pgdg100+1))
Type "help" for help.

postgres=#
```

.. or if you prefer try a graphical client, for example [postico](https://eggerapps.at/postico/)

-

# Run service

`bundle exec ruby main.rb`

# Run Tests

`bundle exec rspec spec`

# Caveats

The following addendums should be read in conjunction with [the project steps](http://loyaltynz.github.io/hoodoo/guides_0300_active_record.html)

## Section 2

- Search for ruby versions `2.3.7` and change to  `2.7.3` across the generated project
- Run `bundle install`
- Before running `bundle exec rake db:create`, add `host`, `user` and `password` values to `config/database.yml` as follows:

```
default: &default
  adapter: postgresql
  encoding: utf8
  database: service_person_development
  host: localhost
  user: postgres
  password: password

...
```
- When testing via `curl` commands pass the outoput through the `jq` command, to make it more readable eg: change:
```
curl http://localhost:9292/v1/people  --header "Content-Type: application/json; charset=utf-8"
```
to
```
curl http://localhost:9292/v1/people  --header "Content-Type: application/json; charset=utf-8" | jq .
```
- Remove `spec/generators/effective_date_spec.rb` and `spec/generators/utils_spec.rb`
- Rename `spec/service/integration/example_spec.rb` -> `spec/service/integration/person_spec.rb` and add specs to test `get, post, patch` and `delete`.
- Implementation spec `spec/service/implementation/person_spec.rb` tests db behaviour

