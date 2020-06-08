%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc DB module for dlock
%%% @end
%%%-------------------------------------------------------------------
-module(dlock_db).
-behaviour(gen_server).

%% API
-export([start_link/0, acquire/1]).
%% DB
-export([create_tables/0, delete_tables/0, restore_tables/0]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-include_lib("dlock/include/dlock.hrl").

%% Macros
-define(SERVER, ?MODULE).

%% Records
-record(item, {
  name,
  lock_id
}).

-record(lock, {
  id,
  callback
}).

-record(queue, {
  id,
  callback,
  created,
  timeout = 1000,
  items = []
}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


-spec acquire(Request :: #request{}) -> ok.
acquire(Request) ->
  gen_server:cast(?SERVER, {acquire, Request}).


%% Table maintenance functions

create_tables() ->
  {atomic, ok} = mnesia:create_table(item, [{attributes, record_info(fields, item)}, {disc_copies, [node()]}]),
  {atomic, ok} = mnesia:create_table(lock, [{attributes, record_info(fields, lock)}, {disc_copies, [node()]}]),
  {atomic, ok} = mnesia:create_table(queue, [{attributes, record_info(fields, queue)}, {disc_copies, [node()]}]).

delete_tables() ->
  {atomic, ok} = mnesia:delete_table(item),
  {atomic, ok} = mnesia:delete_table(lock),
  {atomic, ok} = mnesia:delete_table(queue).

restore_tables() ->
  delete_tables(),
  create_tables().

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

init([]) ->
  {ok, #{}}.

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
