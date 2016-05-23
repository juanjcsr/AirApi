FROM elixir:1.2.5

MAINTAINER Shane Sveller <shane@shanesveller.com>

RUN apt-get update -q && \
    apt-get -y install \
    apt-transport-https \
    curl \
    libpq-dev \
    postgresql-client \
    && apt-get clean -y && \
    rm -rf /var/cache/apt/*

RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_4.x jessie main' > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update -q && \
    apt-get install -y \
    nodejs \
    && apt-get clean -y && \
    rm -rf /var/cache/apt/*

RUN npm install -g npm@3.8.9
RUN mix local.hex --force && \
    mix local.rebar --force
ENV VERSION "0.0.1"
ENV APP_NAME air_api
ENV PORT 4000
EXPOSE $PORT

RUN mkdir /app
WORKDIR /app
COPY rel/air_api/releases/$VERSION/air_api.tar.gz /app/air_api.tar.gz
RUN tar xvfz air_api.tar.gz

WORKDIR /app/releases/$VERSION
ENTRYPOINT ["./air_api.sh"]
CMD ["foreground"]
