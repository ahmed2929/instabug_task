# Dockerfile
FROM ruby:3.0.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY wait-for-it.sh /usr/wait-for-it.sh
RUN chmod +x /usr/wait-for-it.sh
COPY entrypoint.sh /usr/entrypoint.sh
RUN chmod +x /usr/entrypoint.sh
RUN bundle install
COPY . /myapp
COPY wait-for-it.sh /usr/bin/
RUN chmod +x /usr/bin/wait-for-it.sh

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 4000

# Start the main process.
CMD ["foreman", "start"]