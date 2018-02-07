FROM erlang:20.2.2

COPY . /code/

WORKDIR /code

RUN rebar3 as production release

EXPOSE 8080

CMD ["/code/_build/production/rel/chat_backend/bin/chat_backend", "foreground"]
