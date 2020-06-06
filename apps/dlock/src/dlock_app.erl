%%%-------------------------------------------------------------------
%% @doc dlock public API
%% @end
%%%-------------------------------------------------------------------

-module(dlock_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    dlock_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
