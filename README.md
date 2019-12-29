[![Build Status](https://travis-ci.org/Ichaelus/dead_crumbs.svg?branch=master)](https://travis-ci.org/Ichaelus/dead_crumbs)

# Dead Crumbs
You can use Dead Crumbs to generate a secret, which is then split across multiple keys. These keys can later be re-assembled to the secret.

# Development

## Setup

- Install [ruby 2.5.3](https://github.com/rbenv/rbenv#installation)
- Install [Node via NVM](https://github.com/nvm-sh/nvm#install--update-script) and run `nvm use` to use the projects Node version
- Install [yarn](https://yarnpkg.com/lang/en/docs/install/)
- Setup a redis server `sudo apt-get install redis-server `
- Install bundler `gem install bundler`
- Run `bundle exec bin/setup`
- Run server `bundle exec bin/rails s` and go to [http://dead_crumbs.vcap.me:3000/](http://dead_crumbs.vcap.me:3000/)

## Deployment

```
git push heroku
heroku run rails db:migrate
```

Before the first deploy you need to set the secrets required in `config/secrets.yml`:

```
heroku config:set SECRET_KEY_BASE=some_secret
```

## Tests

- Install `chromedriver` and add it to path variables
- Run unit tests with `bundle exec rspec`
- Run integration tests with `bundle exec cucumber`

Debugging hint: You can disable headless mode for javascript tests with `CHROME_HEADLESS=false bundle exec cucumber`.
