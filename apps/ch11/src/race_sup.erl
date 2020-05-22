%%%-------------------------------------------------------------------
%% @doc Race top level supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(race_sup).
-behaviour(supervisor).

%% API
-export([start_link/0, add_racer/1]).

%% supervisor
-export([init/1]).

%% Macros
-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

-spec start_link() -> {ok, pid()}.
start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

-spec add_racer(Id:: supervisor:child_id()) -> {ok, pid()}.
add_racer(Id) ->
  ChildSpec = #{id => Id,
    modules => [racer_gs],
    restart => permanent, shutdown => 2000,
    start => {racer_gs, start_link, []},
    type => worker
  },
  supervisor:start_child(?SERVER, ChildSpec).

%%%===================================================================
%%% Spawning and supervisor implementation
%%%===================================================================

%% @doc start with 1 Racer, the 'champion'
init([]) ->
  SupFlags = #{strategy => one_for_one,
    intensity => 1,
    period => 1},
  Child = #{
    id => champion,
    start => {racer_gs, start_link, []},
    restart => permanent,
    shutdown => 2000,
    type => worker,
    modules => [racer_gs]
  },
  ChildSpecs = [Child],
  {ok, {SupFlags, ChildSpecs}}.

%%%===================================================================
%%% Internal API
%%%===================================================================

