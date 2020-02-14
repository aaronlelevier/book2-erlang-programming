%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Feb 2020 6:29 AM
%%%-------------------------------------------------------------------
-module(ch5_ex2_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").


start_test() ->
  Server = ch5_ex2:server_name(),
  ?assertEqual(undefined, whereis(Server)),

  % start
  ?assertEqual(ok, ch5_ex2:start()),
  ?assertEqual(true, is_pid(whereis(Server))),

  % stop
  ?assertEqual(ok, ch5_ex2:stop()),
  ?assertEqual(undefined, whereis(Server)).

a_client_can_allocate_deallocate_its_own_frequencies_test() ->
  % start
  ?assertEqual(ok, ch5_ex2:start()),

  % allocate
  Freq1 = 1,
  ?assertEqual({ok, Freq1}, ch5_ex2:allocate()),

  % deallocate
  ?assertEqual(ok, ch5_ex2:deallocate(Freq1)),

  % stop
  ?assertEqual(ok, ch5_ex2:stop()).

a_client_cant_deallocate_another_clients_frequency_test() ->
  % start
  ?assertEqual(ok, ch5_ex2:start()),

  % allocate
  Freq1 = 1,
  ?assertEqual({ok, Freq1}, ch5_ex2:allocate()),

  % deallocate
  ?assertEqual(ok, ch5_ex2:deallocate(Freq1)),

  % stop
  ?assertEqual(ok, ch5_ex2:stop()).
