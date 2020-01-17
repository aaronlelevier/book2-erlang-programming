%%%-------------------------------------------------------------------
%% @doc ch4 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch4_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch4_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
