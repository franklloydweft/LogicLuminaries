#!/bin/sh
set -eu

IMAGE=logicluminaries-local-ci:latest
COMMAND="${1:-all}"

case "$COMMAND" in
    all|lint|typecheck|test) ;;
    *)
        echo "Usage: $0 [all|lint|typecheck|test]" >&2
        exit 2
        ;;
esac

docker build -f local-ci.dockerfile -t "$IMAGE" .
docker run --rm -v "$PWD:/app" -w /app "$IMAGE" "$COMMAND"
