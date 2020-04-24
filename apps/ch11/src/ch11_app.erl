%%%-------------------------------------------------------------------
%% @doc ch11 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch11_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch11_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
