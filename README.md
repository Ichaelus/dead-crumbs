[![Build Status](https://travis-ci.org/Ichaelus/dead_crumbs.svg?branch=master)](https://travis-ci.org/Ichaelus/dead_crumbs)

# Dead Crumbs
Dead Crumbs is a platform to pitch and find open-source web applications.

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


## Tests

- Install `chromedriver` and add it to path variables
- Run unit tests with `bundle exec rspec`
- Run integration tests with `bundle exec cucumber`

Debugging hint: You can disable headless mode for javascript tests with `CHROME_HEADLESS=false bundle exec cucumber`.


## ToDos

### General

* Hide the file upload behind an icon

### Key Generation
* If only one user is present, give him all keys
* If multiple users are connected to the same "room" (URL, websocket), key parts are distributed to them

### Key Combination
* If only one user is present, he needs to upload all (k) key parts to get the secret code
* If multple users are connected to the same "room", they must submit their parts (using a websocket).
  Once k keys were submitted, they are all distributed
