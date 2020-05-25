%%%-------------------------------------------------------------------
%% @doc ch12 top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(ch12_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional

init([]) ->
    SupFlags = #{strategy => one_for_one,
                 intensity => 1,
                 period => 1},
    ChildSpecs = [
      bike_child_spec(),
      bike_db_child_spec()
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions

bike_child_spec() -> #{
  id => 0,
  start => {bike, start_link, []},
  restart => permanent,
  shutdown => 2000,
  type => worker,
  modules => [bike]
}.

bike_db_child_spec() -> #{
  id => 1,
  start => {bike_db, start_link, []},
  restart => permanent,
  shutdown => 2000,
  type => worker,
  modules => [bike_db]
}.
