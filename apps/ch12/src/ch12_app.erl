%%%-------------------------------------------------------------------
%% @doc ch12 public API
%% @end
%%%-------------------------------------------------------------------

-module(ch12_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ch12_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
