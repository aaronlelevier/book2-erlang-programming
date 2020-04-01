%%%-------------------------------------------------------------------
%% @doc ch10 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch10_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch10_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
