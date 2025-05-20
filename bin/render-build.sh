#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
yarn build

./bin/rails assets:precompile
./bin/rails assets:clean

./bin/rails db:prepare
