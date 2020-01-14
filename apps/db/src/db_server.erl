%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(db_server).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(db_server_state, {}).

-include_lib("stdlib/include/qlc.hrl").
-include_lib("book2/include/records.hrl").

-compile(export_all).

%%%===================================================================
%%% Public API and gen_server implementation
%%%===================================================================

create_tables() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  mnesia:create_table(user, [{attributes, record_info(fields, user)}, {disc_copies, [node()]}]),
  mnesia:stop().

select(Table) ->
  do(qlc:q([X || X <- mnesia:table(Table)])).

insert(Row) ->
  F = fun() -> mnesia:write(Row) end,
  mnesia:transaction(F).

do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.


%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #db_server_state{}}.

handle_call(_Request, _From, State = #db_server_state{}) ->
  {reply, ok, State}.

handle_cast(_Request, State = #db_server_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #db_server_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #db_server_state{}) ->
  ok.

code_change(_OldVsn, State = #db_server_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
