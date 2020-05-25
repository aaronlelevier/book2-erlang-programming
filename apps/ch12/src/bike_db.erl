%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc Bike Database module
%%% But nothing is Bike specific at this point
%%%
%%% References:
%%% try/catch docs: https://erlang.org/doc/reference_manual/expressions.html#try
%%% @end
%%%-------------------------------------------------------------------
-module(bike_db).
-behaviour(gen_server).
-include_lib("book2/include/macros.hrl").

%% API
-export([start_link/0]).
-export([add/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%% DB
-export([upsert/2]).

%% Macros
-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

-spec add(BikeData :: map()) -> {created, Id} | {updated, Id} when
  Id :: integer().
add(BikeData) ->
  gen_server:call(?SERVER, {add, BikeData}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

init([]) ->
  {ok, #{next_id => 0}}.

handle_call({add, BikeData}, _From, State) ->
  {Reply, State2} = upsert(BikeData, State),
  {reply, Reply, State2};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

upsert(BikeData, State) ->
  Key = maps:get(product, BikeData),
  try maps:get(Key, State) of
    Existing ->
      State2 = State#{Key => maps:merge(Existing, BikeData)},
      Id = maps:get(id, Existing),
      {{updated, Id}, State2}
  catch error:{badkey,Key} ->
    Count = maps:get(count, State),
    Id = Count + 1,
    BikeData2 = BikeData#{id => Id},
    State2 = State#{Key => BikeData2, count => Id},
    {{created, Id}, State2}
  end.
