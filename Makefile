.PHONY: init
init:
	poetry install

.PHONY: serve
serve:
	poetry run mkdocs serve -a 0.0.0.0:8000

.PHONY: build
build:
	poetry run mkdocs build

.PHONY: gh-deploy
gh-deploy:
	poetry run mkdocs gh-deploy
