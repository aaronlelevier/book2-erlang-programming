%%%-------------------------------------------------------------------
%% @doc monads public API
%% @end
%%%-------------------------------------------------------------------

-module(monads_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    monads_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
