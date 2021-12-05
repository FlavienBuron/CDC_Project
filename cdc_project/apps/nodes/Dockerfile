
# FROM elixir:latest

# RUN mkdir /app
# WORKDIR /app

# COPY . /app

# RUN mix local.hex --force \
#  && mix local.rebar --force

# RUN MIX_ENV=prod mix do deps.get, compile, release 

# ENTRYPOINT ["/app/_build/prod/rel/nodes/bin/nodes"]
# CMD ["start", "remote"]


FROM elixir:latest

ENV MIX_HOME=/opt/mix

RUN mkdir /nodes

WORKDIR /nodes

RUN mix do local.hex --force, local.rebar --force

 

# ENV APP_NAME=node@node
# ENV HOSTNAME node
ENV PUID 1000
ENV PGID 1000

COPY . /nodes
RUN MIX_ENV=prod mix do deps.get, compile, release

RUN mix deps.get 
RUN mix compile

RUN chown -R ${PUID} /nodes
RUN chgrp -R ${PGID} /nodes

USER ${PUID}

# RUN cd /nodes



ENTRYPOINT ["/nodes/_build/prod/rel/nodes/bin/nodes"]
CMD ["start", "remote"]

# ENTRYPOINT iex --sname ${HOSTNAME} --cookie cookie -S mix