%%%-------------------------------------------------------------------
%% @doc ch5 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch5_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch5_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
