.PHONY: help venv freeze test coverage lint run gunicorn clean

VENV_NAME?=venv
BIN_DIR=$(abspath $(VENV_NAME)/bin/)
PYTHON=$(BIN_DIR)/python
SRC=./src

.DEFAULT: help
help:
	@echo "Will use python at ${PYTHON}"
	@echo "make help           print this help"
	@echo "make venv           create a virtual environment to hold all dependencies"
	@echo "make dependencies   install all dependencies"
	@echo "make freeze         freeze pip dependencies, i.e. show all installed packages"
	@echo "make test           run tests"
	@echo "make lint           run linter"
	@echo "make run            run application (with flask development server)"
	@echo "make gunicorn       run application (with gunicorn)"
	@echo "make jupyter        start jupyter's notebook server"
	@echo "make algo-nb        run the jupyter notebook headlessly and in-place"
	@echo "make algo-html      run the jupyter notebook headlessly and render it into a HTML file"

venv: $(BIN_DIR)/activate

$(BIN_DIR)/activate: $(SRC)/requirements.txt
	@echo "Using python $(PYTHON)"
	test -d $(VENV_NAME) || (pip3 install --user virtualenv && python3 -m virtualenv $(VENV_NAME))
	${PYTHON} -m pip install -U pip
	cd $(SRC) && ${PYTHON} -m pip install -r ./requirements.txt
	touch $(BIN_DIR)/activate

freeze: venv
	${PYTHON} -m pip freeze

dependencies: venv $(SRC)/requirements.txt
	cd $(SRC) && ${PYTHON} -m pip install -r ./requirements.txt
	touch $(BIN_DIR)/activate

test: venv
	cd $(SRC) && ${PYTHON} -m pytest

coverage: venv
	cd $(SRC) && ${BIN_DIR}/coverage run -m pytest
	cd $(SRC) && ${BIN_DIR}/coverage report
	cd $(SRC) && ${BIN_DIR}/coverage html --fail-under=100

open-cov-report:
	open $(SRC)/htmlcov/index.html

lint: venv
	${PYTHON} -m pylint $(SRC)

run: venv
	cd $(SRC) && ${PYTHON} run.py

gunicorn: venv
	cd $(SRC) && ${PYTHON} -m gunicorn --preload wsgi:application

clean:
	# there is some weirdness with git ignore patterns and having a leading dot in the path (i.e. ./src/ != src/)
	#git clean -f -d -x --exclude='/*/config/secret.py'
	rm -rf $(VENV_NAME)
