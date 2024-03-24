#!/bin/bash
set -e
bundle exec rake db:create
bundle exec rake db:migrate
rm -f /myapp/tmp/pids/server.pid


exec "$@"