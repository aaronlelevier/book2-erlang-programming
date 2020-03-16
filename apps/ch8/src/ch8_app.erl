%%%-------------------------------------------------------------------
%% @doc ch8 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch8_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch8_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
