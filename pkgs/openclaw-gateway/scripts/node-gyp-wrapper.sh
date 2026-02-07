#!/bin/sh
if [ "$1" = "rebuild" ]; then
  shift
  "$REAL_NODE_GYP" configure "$@" && "$REAL_NODE_GYP" build "$@"
  exit $?
fi
exec "$REAL_NODE_GYP" "$@"
