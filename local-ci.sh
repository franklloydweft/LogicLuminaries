#!/bin/sh
set -eu

run_lint() {
    cd /app
    black . --check --verbose --diff --color
    flake8 --max-line-length=100 --ignore=F401,W503 .
    cd /app/frontend
    npx --yes prettier --check .
}

run_typecheck() {
    cd /app
    DJANGO_TESTING=1 PYTHONPATH="/app/backend${PYTHONPATH:+:$PYTHONPATH}" mypy -p backend
}

run_tests() {
    cd /app
    DJANGO_TESTING=1 coverage run --omit=/usr/*,backend/manage.py,backend/sudoku/tests.py,backend/sudoku/views.py,backend/sudoku/migrations/*,backend/src/settings.py backend/manage.py test backend/sudoku
    coverage report
}

case "${1:-all}" in
    lint)
        run_lint
        ;;
    typecheck)
        run_typecheck
        ;;
    test)
        run_tests
        ;;
    all)
        run_lint
        run_typecheck
        run_tests
        ;;
    *)
        echo "Usage: $0 [all|lint|typecheck|test]" >&2
        exit 2
        ;;
esac
