%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Feb 2020 6:09 AM
%%%-------------------------------------------------------------------
-module(ch5_ex3_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

-define(EVENT_MGR, event_manager).

top_setup() -> ch5_ex3:start(?EVENT_MGR, []).

top_cleanup(_) -> ch5_ex3:stop(?EVENT_MGR).

%% handler list

can_get_handler_list() ->
  ?assertEqual([], ch5_ex3:handler_list(?EVENT_MGR)),
  Handler = ch5_io_handler,
  ?assertEqual(
    ok,
    ch5_ex3:add_handler(?EVENT_MGR, Handler, [0])),
  ?assertEqual([Handler], ch5_ex3:handler_list(?EVENT_MGR)).
can_get_handler_list_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [fun can_get_handler_list/0]}.

can_delete_handler() ->
  Handler = ch5_log_handler,
  Filename = "test.log",
  ?assertEqual(
    ok,
    ch5_ex3:add_handler(?EVENT_MGR, Handler, [Filename])),
  ?assertEqual([Handler], ch5_ex3:handler_list(?EVENT_MGR)),
  ?assertEqual(
    {data, {file, [Filename]}},
    ch5_ex3:delete_handler(?EVENT_MGR, Handler)),
  ?assertEqual([], ch5_ex3:handler_list(?EVENT_MGR)).
can_delete_handler_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [fun can_delete_handler/0]}.

can_get_data_for_io_handler() ->
  Handler = ch5_io_handler,
  InitCount = 0,
  % init io_handler with an event count of 0
  ?assertEqual(
    ok,
    ch5_ex3:add_handler(?EVENT_MGR, Handler, InitCount)),
  % get_data returns init count of 0
  ?assertEqual(
    {data, InitCount}, ch5_ex3:get_data(?EVENT_MGR, Handler)),
  % handler is in handler list
  ?assertEqual(
    [Handler],
    ch5_ex3:handler_list(?EVENT_MGR)),
  % send event and count is incremented
  Event = {raise_alarm, 100, "my event"},
  % send a valid event
  ?assertEqual(ok, ch5_ex3:send_event(?EVENT_MGR, Event)),
  % count is incremented
  ?assertEqual(
    {data, InitCount + 1}, ch5_ex3:get_data(?EVENT_MGR, Handler)).
can_get_data_for_io_handler_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [fun can_get_data_for_io_handler/0]}.

can_swap_handlers() ->
  Handler = ch5_log_handler,
  % add handler
  ?assertEqual(
    ok,
    ch5_ex3:add_handler(?EVENT_MGR, Handler, ["test.log"])),
  % handler is now in handler's list
  ?assertEqual([ch5_log_handler], ch5_ex3:handler_list(?EVENT_MGR)),
  % swap for a diff handler
  Handler2 = ch5_log_handler2,
  ?assertEqual(
    ok,
    ch5_ex3:swap_handlers(?EVENT_MGR, Handler, Handler2)),
  % now the old handler is swapped for the new one
  ?assertEqual([Handler2], ch5_ex3:handler_list(?EVENT_MGR)).
can_swap_handlers_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [fun can_swap_handlers/0]
  }.
