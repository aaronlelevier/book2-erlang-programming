%%%-------------------------------------------------------------------
%% @doc ch13 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch13_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch13_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
