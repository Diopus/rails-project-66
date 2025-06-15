# Github quality
[![Actions Status](https://github.com/Diopus/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Diopus/rails-project-66/actions)
[![CI](https://github.com/Diopus/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/Diopus/rails-project-66/actions/workflows/ci.yml)

## Info 
The **Github quality** is a service similar to codeclimate.com where developers can run code checks on their repositories and get a report on the state of their codebase and current issues.

Enjoy!

[Collective-blog](https://github-quality-mmyo.onrender.com/)

Deployed on: [Render](https://render.com/)

## Requirements

* Ruby 3.2.2
* Node.js & npm
* SQLite for local
* PostgreSQL for production

## Tech stack
* Ruby on Rails, Rails.cache (Redis), Active Job (Sidekiq/async adapter), ActionMailer
* Webhooks (GitHub events), Octokit, Dry-container (DI), WebMock, Open3, Bootstrap, Sentry
* AASM, pundit, omniauth, rails-i18n, minitest

## Setup

```bash
make setup
```

## Running in development
For local running there're some extra tools required.

### dotenv
Install [dotenv](https://github.com/bkeepers/dotenv) gem
Create .env from the template:
```bash
make setup-env
```
Update the .env file with your credentials (e.g., ID and Secret).

### ngrok
Install [ngrok](https://ngrok.com/)

Run with command:
```bash
make ngrok http 3000
```
Get the forwarding IP and update BASE_URL in .env with format like "https://7584-213-147-166-105.ngrok-free.app".


## Running in production
Following instances have to be created on Render:
* Web Service
* Background Worker
* Valkey (redis cache store)
* pg instance

Don't forget to fill up the ENV variables (DATABASE_URL, RAILS_MASTER_KEY, WEB_CONCURRENCY, REDIS_URL + variables from .env.example)

## How to run the test suite

To run tests:
```bash
make test
```
To run linters:
```bash
make lint
```
Or both:
```bash
make check
```
