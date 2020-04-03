%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 01. Apr 2020 6:41 AM
%%%-------------------------------------------------------------------
-module(ch10_reading_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

-define(TABLE, countries).

%% initial table create/delete tests -------------------------------------

table_create_and_delete_test() ->
  % table doesn't exist to start
  ?assertEqual(undefined, ets:info(?TABLE)),
  % create
  ?assertEqual(?TABLE, ch10_reading:new_table()),
  % delete
  ?assertEqual(true, ch10_reading:close_table()),
  % table now closed
  ?assertEqual(undefined, ets:info(?TABLE)).


%% table create/delete is already working tests --------------------------

open_table_setup() ->
  ch10_reading:new_table().

close_table_cleanup(_) ->
  ch10_reading:close_table().

ets_table_with_records_test_() ->
  {setup,
    fun open_table_setup/0,
    fun close_table_cleanup/1,
    [
      fun table_exists/0,
      fun insert_records_into_table/0
    ]}.

table_exists() ->
  Ret = ets:info(?TABLE),
  % if table doesn't exist, it will be 'undefined'
  ?assert(is_list(Ret)).

insert_records_into_table() ->
  % empty table to start
  ?assertEqual('$end_of_table', ets:first(?TABLE)),

  ch10_reading:insert_records(),

  % table now has data
  ?assertEqual(x, ets:first(?TABLE)).
