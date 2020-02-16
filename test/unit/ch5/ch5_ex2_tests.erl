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

  % worker allocates a frequency
  Worker = spawn(ch5_ex2, worker, [[]]),
  Reply = ch5_ex2:response(Worker, allocate),
  Freq2 = 2,
  ?assertEqual({ok, Freq2}, Reply),

  % worker can deallocate their own frequency
  Reply2 = ch5_ex2:response(Worker, {deallocate, Freq2}),
  ?assertEqual(ok, Reply2),

  % worker can't deallocate another client's frequency
  Reply3 = ch5_ex2:response(Worker, {deallocate, Freq1}),
  ?assertEqual(error, Reply3),

  % client can deallocate it's frequency
  ?assertEqual(ok, ch5_ex2:deallocate(Freq1)),

  % stop
  ?assertEqual(ok, ch5_ex2:stop()).

count_test() ->
  % start
  ?assertEqual(ok, ch5_ex2:start()),

  % allocate
  Freq1 = 1,
  ?assertEqual({ok, Freq1}, ch5_ex2:allocate()),

  ?assertEqual({ok, 1}, ch5_ex2:count(in_use)),

  % client can deallocate it's frequency
  ?assertEqual(ok, ch5_ex2:deallocate(Freq1)),

  ?assertEqual({ok, 0}, ch5_ex2:count(in_use)),

  % stop
  ?assertEqual(ok, ch5_ex2:stop()).

frequencies_test() ->
  ?assertEqual(ok, ch5_ex2:start()),

  Frequencies = ch5_ex2:frequencies(),
  ?assertEqual({[1, 2], []}, Frequencies),

  % frequency server is still alive
  ?assert(is_pid(whereis(ch5_ex2:server_name()))),

  Freq1 = 1,
  ?assertEqual({ok, Freq1}, ch5_ex2:allocate()),

  Frequencies2 = ch5_ex2:frequencies(),
  ?assertEqual({[2], [{self(), 1}]}, Frequencies2),

  ?assertEqual(ok, ch5_ex2:deallocate(Freq1)),

  Frequencies3 = ch5_ex2:frequencies(),
  ?assertEqual({[1, 2], []}, Frequencies3),

  % now we can stop
  ?assertEqual(ok, ch5_ex2:stop()).

can_only_stop_if_no_frequencies_are_allocated_test() ->
  ?assertEqual(ok, ch5_ex2:start()),

  Freq1 = 1,
  ?assertEqual({ok, Freq1}, ch5_ex2:allocate()),

  ?assertEqual({ok, 1}, ch5_ex2:count(in_use)),
  ?assertEqual({error, frequencies_currently_allocated}, ch5_ex2:stop()),

  ?assertEqual(ok, ch5_ex2:deallocate(Freq1)),

  % now we can stop
  ?assertEqual({ok, 0}, ch5_ex2:count(in_use)),
  ?assertEqual(ok, ch5_ex2:stop()).

can_allocate_more_than_one_frequency_at_a_time_test() ->
  % start
  ?assertEqual(ok, ch5_ex2:start()),

  % allocate
  Freq1 = 1,
  Freq2 = 2,
  Freqs = [Freq1, Freq2],
  ?assertEqual({ok, Freqs}, ch5_ex2:allocate(2)),

  % 2 frequencies have been allocated
  ?assertEqual({ok, 2}, ch5_ex2:count(in_use)),

  % deallocate
  ?assertEqual(ok, ch5_ex2:deallocate(Freq1)),
  ?assertEqual(ok, ch5_ex2:deallocate(Freq2)),

  % stop
  ?assertEqual(ok, ch5_ex2:stop()).