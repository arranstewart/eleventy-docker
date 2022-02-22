#!/usr/bin/env sh

if [ "$#" -lt 2 ]; then
  echo >&2 'error: expected at least 2 args, PACKAGE_DIR ELEVENTY_JS_FILE'
  exit 1
fi

PACKAGE_DIR=$1
ELEVENTY_JS_FILE=$2
shift 2

set -x
NODE_PATH=${PACKAGE_DIR}/node_modules npx \
  --prefix=${PACKAGE_DIR} \
  eleventy --config=${ELEVENTY_JS_FILE} "$@"

