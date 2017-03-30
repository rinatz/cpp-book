.PHONY: provision
provision:
	docker-compose build

.PHONY: init
init:
	docker-compose run --rm gitbook gitbook init

.PHONY: clean
clean:
	rm -rf docs/_book

.PHONY: build
build:
	docker-compose run --rm gitbook gitbook build

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down
