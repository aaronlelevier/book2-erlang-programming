%%%-------------------------------------------------------------------
%% @doc ch3 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch3_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch3_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
