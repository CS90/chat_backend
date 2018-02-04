-module(chat_backend_ws_root_handler).

-export([init/2]).
-export([websocket_init/1, websocket_handle/2, websocket_info/2, terminate/3]).

init(Req, Opts) ->
  {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
  pg2:create(websocket_connections),
  pg2:join(websocket_connections, self()),
  {ok, State}.

websocket_handle({text, Msg}, State) ->
  [Pid ! Msg || Pid <- pg2:get_members(websocket_connections)],
  %% {reply, {text, << "That's what she said! ", Msg/binary >>}, State};
  {ok, State};
websocket_handle(_Data, State) ->
  {ok, State}.

websocket_info({text, _Ref, Msg}, State) ->
  {reply, {text, Msg}, State};
websocket_info(Info, State) ->
  {ok, Message} = maps:find(<<"message">>, jsx:decode(Info, [return_maps])),
  {reply, {text, Message}, State}.

terminate(_Reason, _PartialReq, _State) ->
  pg2:leave(websocket_connections, self()),
  ok.
