%%%-------------------------------------------------------------------
%% @doc chat_backend public API
%% @end
%%%-------------------------------------------------------------------

-module(chat_backend_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", chat_backend_ws_root_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch},
		middlewares => [cowboy_router, cowboy_handler]
	}),
    chat_backend_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
