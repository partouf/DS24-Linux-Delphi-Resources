#!/bin/sh

ROOT=$(pwd)
export POETRY_HOME="$ROOT/.poetry"
export POETRY_VENV="$ROOT/.venv"
export POETRY_DEPS="$POETRY_VENV/.deps"

PATH="$PATH:$POETRY_HOME/bin"

curl -sSL https://install.python-poetry.org | python3 -

poetry install

poetry run pytest -q smoketest.py --approvaltests-use-reporter='PythonNative'
