.PHONY: provision
provision:
	docker-compose build

.PHONY: init
init:
	docker-compose run --rm gitbook gitbook init

.PHONY: build
build:
	docker-compose run --rm gitbook gitbook build
	touch src/_book/.nojekyll

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: sync
sync:
	rsync -av --delete src/_book/ docs/
