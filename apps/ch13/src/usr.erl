%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2020 7:12 AM
%%%-------------------------------------------------------------------
-module(usr).
-author("Aaron Lelevier").
-vsn(1.0).
-export([create/1]).
%% Mnesia
-export([create_tables/0, ensure_loaded/0, read/1, write/1, delete/1, keys/0]).


-include_lib("ch10/include/usr.hrl").


create(Id) ->
  #usr{msisdn=Id + 1000, id=Id}.


%% Mnesia code

create_tables() ->
  Fields = record_info(fields, usr),
  {atomic, ok} = mnesia:create_table(
    usr, [{disc_copies, [node()]}, {type, set}, {attributes, Fields}, {index, [id]}]).


%% blocking wait for all Mnesia tables to be loaded
ensure_loaded() ->
  ok = mnesia:wait_for_tables([usr], 5000).


read(Index) ->
  mnesia:transaction(fun() -> mnesia:read({usr, Index}) end).


write(Usr) ->
  mnesia:transaction(fun() -> mnesia:write(Usr) end).


delete(Index) ->
  mnesia:transaction(fun() -> mnesia:delete({usr, Index}) end).


%% @doc returns all indexes
keys() ->
  {ok, _L} = mnesia:transaction(fun() -> mnesia:all_keys(usr) end).