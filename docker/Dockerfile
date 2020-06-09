FROM ruby:2.7-slim

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        gosu \
        libcurl4-openssl-dev \
        gcc \
    && rm -rf /var/lib/apt/list/*

WORKDIR /app

RUN gem update && gem install bundler -v 2.1.4

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install -j4

COPY . .

ENTRYPOINT ["./docker/entrypoint.sh"]

CMD ["bin/code_generator", "./definitions"]
