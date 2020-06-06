%%%-------------------------------------------------------------------
%% @doc dlock top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(dlock_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{
      strategy => one_for_one,
      intensity => 1, % allowed restarts
      period => 1 % seconds
    },
    ChildSpecs = [
      dlock_spec(),
      dlock_db_spec()
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions

dlock_spec() -> #{
  id => 0,
  start => {dlock, start_link, []},
  restart => permanent,
  shutdown => 5000, % 5 seconds
  type => worker,
  modules => [dlock, gen_server]
}.

dlock_db_spec() -> #{
  id => 1,
  start => {dlock_db, start_link, []},
  restart => permanent,
  shutdown => 5000, % 5 seconds
  type => worker,
  modules => [dlock_db, gen_server]
}.