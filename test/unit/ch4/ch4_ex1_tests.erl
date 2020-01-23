%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:35 AM
%%%-------------------------------------------------------------------
-module(ch4_ex1_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

can_start_and_stop_echo_server_test() ->
  ?assertEqual(undefined, whereis(echo)),

  ?assertEqual(ok, ch4_ex1:start()),
  ?assertEqual(true, is_pid(whereis(echo))),

  ?assertEqual(ok, ch4_ex1:stop()),
  ?assertEqual(undefined, whereis(echo)).

multiple_starts_returns_error_test() ->
  ?assertEqual(ok, ch4_ex1:start()),

  ?assertEqual({error, already_started}, ch4_ex1:start()),

  ?assertEqual(ok, ch4_ex1:stop()).

echo_server_can_print_term_test() ->
  ?assertEqual(ok, ch4_ex1:start()),
  ?assertEqual(true, is_pid(whereis(echo))),

  Term = "hello world",
  ch4_ex1:print(Term),

  ?assertEqual(true, is_pid(whereis(echo))),

  ?assertEqual(ok, ch4_ex1:stop()),
  ?assertEqual(undefined, whereis(echo)).
