%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc stats_handler tests
%%%
%%% @end
%%% Created : 19. Feb 2020 5:02 AM
%%%-------------------------------------------------------------------
-module(ch5_stats_handler_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

-define(EVENT_MGR, event_manager).
-define(HANDLER, ch5_stats_handler).

top_setup() ->
  ch5_ex3:start(?EVENT_MGR, []),
  % add handler, which we need for all tests
  ?assertEqual(
    ok,
    ch5_ex3:add_handler(?EVENT_MGR, ?HANDLER, [])).

top_cleanup(_) -> ch5_ex3:stop(?EVENT_MGR).

init_state_is_an_empty_list_of_stats() ->
  ?assertEqual({data, []}, ch5_ex3:get_data(?EVENT_MGR, ?HANDLER)).

send_events_and_stats_are_tracked() ->
  ch5_ex3:send_event(?EVENT_MGR, {raise_alarm, 1, "cabinet"}),
  ?assertEqual(
    {data, [{{raise_alarm, "cabinet"}, 1}]},
    ch5_ex3:get_data(?EVENT_MGR, ?HANDLER)
  ),
  % diff event
  ch5_ex3:send_event(?EVENT_MGR, {clear_alarm, 2, "cabinet"}),
  {data, Data} = ch5_ex3:get_data(?EVENT_MGR, ?HANDLER),
  ?assert(lists:member({{raise_alarm, "cabinet"}, 1}, Data)),
  ?assert(lists:member({{clear_alarm, "cabinet"}, 1}, Data)),
  % same event increments event stats
  ch5_ex3:send_event(?EVENT_MGR, {raise_alarm, 3, "cabinet"}),
  {data, Data2} = ch5_ex3:get_data(?EVENT_MGR, ?HANDLER),
  ?assert(lists:member({{raise_alarm, "cabinet"}, 2}, Data2)),
  ?assert(lists:member({{clear_alarm, "cabinet"}, 1}, Data2)).

stats_handler_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [
      fun init_state_is_an_empty_list_of_stats/0,
      fun send_events_and_stats_are_tracked/0
    ]}.


