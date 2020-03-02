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
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

top_setup() ->
  {ok, _ServerPid} = ch6_ex2:start().

top_cleanup(_) ->
  ok = ch6_ex2:stop().

acquire_and_release_mutex() ->
  {ok, PidA} = ch6_ex2:start_client(),
  ?assertEqual({status, free}, ch6_ex2:status()),

  PidA ! {wait, self()},
  receive ok -> ok end,
  ?assertEqual({status, busy}, ch6_ex2:status()),

  % release
  PidA ! {signal, self()},
  receive ok -> ok end,
  ?assertEqual({status, free}, ch6_ex2:status()).

client_is_linked_to_mutex_and_releases_if_terminated() ->
  {ok, PidA} = ch6_ex2:start_client(),
  ?assertEqual({status, free}, ch6_ex2:status()),

  % client acquires mutex
  PidA ! {wait, self()},
  receive ok -> ok end,
  ?assertEqual({status, busy}, ch6_ex2:status()),

  % client terminates and mutex is released
  exit(PidA, kill),
  % client is monitored in `start_client/0`, so we can wait until it exits
  % to confirm the the server state
  receive
    {'DOWN', _Ref, process, PidA, _Reason} ->
      ok
  end,
  ?assertEqual({status, free}, ch6_ex2:status()).

acquire_and_release_mutex_test_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [
      fun acquire_and_release_mutex/0,
      fun client_is_linked_to_mutex_and_releases_if_terminated/0
    ]}.

%% helpers

assert_pid_is_runnable(Pid) ->
  ?assertEqual({status, runnable}, process_info(Pid, status)).

assert_pid_is_waiting(Pid) ->
  ?assertEqual({status, waiting}, process_info(Pid, status)).

assert_pid_is_stopped(Pid) ->
  ?assertEqual(undefined, process_info(Pid, status)).
