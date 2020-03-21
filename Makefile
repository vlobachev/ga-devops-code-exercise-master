.PHONY: deps
deps:
	pipenv sync --dev --python 3.7

.PHONY: run_write_db
run_write_db:
	pipenv run python src/write_db.py

.PHONY: verify_data_db
verify_data_db:
	pipenv run python src/verify_data_devops.py
