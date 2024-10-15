#!/usr/bin/env bash
# exit on error
set -o errexit

# Unfreeze to allow updating Gemfile.lock
bundle config set frozen false

# Install dependencies
bundle install

# Check if any tables exist
if bundle exec rails db:exists; then
  echo "Database already has tables, skipping migrations and seeds."
else
  # Run migrations and seeds
  echo "Running migrations and seeds..."
  bundle exec rake db:migrate
  bundle exec rake db:seed
fi
