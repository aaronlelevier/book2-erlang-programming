%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Feb 2020 6:43 AM
%%%-------------------------------------------------------------------
-module(ch6_ex2_tests).
-author("aaron lelevier").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

acquire_and_release_mutex_test() ->
  {ok, _ServerPid} = ch6_ex2:start(),

  {ok, PidA} = ch6_ex2:start_client(),
  ?assertEqual({status, free}, ch6_ex2:status()),

  PidA ! {wait, self()},
  receive ok -> ok end,
  ?assertEqual({status, busy}, ch6_ex2:status()),

  % release
  PidA ! {signal, self()},
  receive ok -> ok end,
  ?assertEqual({status, free}, ch6_ex2:status()),

  ?assertEqual(ok, ch6_ex2:stop()).

%% helpers

assert_pid_is_runnable(Pid) ->
  ?assertEqual({status, runnable}, process_info(Pid, status)).

assert_pid_is_waiting(Pid) ->
  ?assertEqual({status, waiting}, process_info(Pid, status)).

assert_pid_is_stopped(Pid) ->
  ?assertEqual(undefined, process_info(Pid, status)).
