setup:
	bin/setup
	yarn run build
	yarn run build:css

test:
	bin/rails test:system test

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/

check: lint test

ci-setup:
	cp -n .env.example .env || true
	yarn install
	bundle install --without production development
	# RAILS_ENV=test bin/rails db:prepare

setup-env:
	@if [ -f .env ]; then \
		echo ".env file already exists"; \
	else \
		cp .env.example .env; \
		echo ".env file created. Please update the .env file with your credentials (e.g., ID and Secret)."; \
	fi

front:
	bin/rails assets:precompile
	bin/rails s