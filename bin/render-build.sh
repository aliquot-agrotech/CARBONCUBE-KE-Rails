#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install --with development test
bundle exec rake db:migrate
bundle exec rake db:seed