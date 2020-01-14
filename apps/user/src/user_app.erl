%%%-------------------------------------------------------------------
%% @doc user public API
%% @end
%%%-------------------------------------------------------------------

-module(user_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    user_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
