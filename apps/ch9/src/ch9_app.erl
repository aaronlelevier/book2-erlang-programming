%%%-------------------------------------------------------------------
%% @doc ch9 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch9_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch9_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
