%%%-------------------------------------------------------------------
%% @doc ch7 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch7_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch7_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
