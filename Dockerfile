FROM erlang:20.2.2

COPY . /code/

WORKDIR /code

RUN rebar3 as production release

RUN ls -la
RUN ls -la _build/prod/rel/chat_backend/bin/

EXPOSE 8080

CMD ["_build/prod/rel/chat_backend/bin/chat_backend", "foreground"]
