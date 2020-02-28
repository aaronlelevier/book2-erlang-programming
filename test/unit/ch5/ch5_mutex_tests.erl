%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Feb 2020 5:57 AM
%%%-------------------------------------------------------------------
-module(ch5_mutex_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").
-include_lib("ch5/include/macros.hrl").


book_example_test() ->
  % start mutex server and confirm that it's running
  ServerPid = ch5_mutex:start(),
  assert_pid_is_runnable(ServerPid),

  PidA = spawn(ch5_mutex, client_loop, []),
  PidA ! wait,
  assert_pid_is_runnable(PidA),

  PidB = spawn(ch5_mutex, client_loop, []),
  PidB ! wait,
  assert_pid_is_runnable(PidA),
  assert_pid_is_runnable(PidB),

  PidA ! {signal, self()},
  receive ok -> ok end,

  PidB ! {signal, self()},
  receive ok -> ok end,

  % stop mutex server
  ch5_mutex:stop(),
  receive ok -> ok end,
  assert_pid_is_stopped(ServerPid).

%% helpers

assert_pid_is_runnable(Pid) ->
  ?assertEqual({status, runnable}, process_info(Pid, status)).

assert_pid_is_waiting(Pid) ->
  ?assertEqual({status, waiting}, process_info(Pid, status)).

assert_pid_is_stopped(Pid) ->
  ?assertEqual(undefined, process_info(Pid, status)).
