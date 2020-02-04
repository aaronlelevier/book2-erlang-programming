%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Jan 2020 6:26 AM
%%%-------------------------------------------------------------------
-module(ch5_process_pattern_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

start_and_stop_test() ->
  Name = waiting_room,
  ?assertEqual(undefined, whereis(Name)),

  % start
  InitData = [],
  ?assertEqual(ok, ch5_process_pattern:start(Name, InitData)),
  ?assertEqual(true, is_pid(whereis(Name))),

  % get count
  ?assertEqual({ok, 0}, ch5_process_pattern:call(Name, count)),

  % stop
  ?assertEqual(ok, ch5_process_pattern:stop(Name)).

add_and_remove_people_to_waiting_list_test() ->
  Name = waiting_room,
  InitData = [],
  ?assertEqual(ok, ch5_process_pattern:start(Name, InitData)),

  % initial count
  ?assertEqual({ok, 0}, ch5_process_pattern:call(Name, count)),

  % add using "call"
  ?assertEqual({ok, 1}, ch5_process_pattern:call(Name, {add, "Bob"})),
  ?assertEqual({ok, 1}, ch5_process_pattern:call(Name, count)),

  % add using "cast"
  ?assertEqual(ok, ch5_process_pattern:cast(Name, {add, "Gary"})),
  ?assertEqual({ok, 2}, ch5_process_pattern:call(Name, count)),

  % remove
  ?assertEqual({ok, "Bob"}, ch5_process_pattern:call(Name, remove)),
  ?assertEqual({ok, 1}, ch5_process_pattern:call(Name, count)),

  % stop
  ?assertEqual(ok, ch5_process_pattern:stop(Name)).

%% TODO: could separate out call/cast tests

