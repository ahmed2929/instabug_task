#!/bin/bash

HOST=$1
PORT=$2
shift
shift
CMD="$@"

until nc -z $HOST $PORT; do
  echo "$HOST:$PORT is unavailable - sleeping"
  sleep 1
done

echo "$HOST:$PORT is up - executing command"
exec $CMD