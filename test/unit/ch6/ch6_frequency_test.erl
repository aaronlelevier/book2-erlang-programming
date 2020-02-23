%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Feb 2020 7:45 AM
%%%-------------------------------------------------------------------
-module(ch6_frequency_test).
-author("aaron lelevier").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

exited_pid_is_allocated_test() ->
  Free = [1, 2],
  Pid = self(),
  Freq = 0,
  Allocated = [{Pid, Freq}],
  ?assertEqual(
    {[0, 1, 2], []},
    ch6_frequency:exited({Free, Allocated}, Pid)).

exited_pid_is_not_allocated_test() ->
  Free = [0, 1, 2],
  Pid = self(),
  Allocated = [],
  ?assertEqual(
    {[0, 1, 2], []},
    ch6_frequency:exited({Free, Allocated}, Pid)).


top_setup() -> ch6_frequency:start().
top_cleanup(_) -> ch6_frequency:stop().
use_link_to_monitor_client_when_allocating_a_frequency() ->
  Worker = spawn(ch6_frequency, worker, [[]]),
  ?assertEqual({ok, 1}, ch5_ex2:response(Worker, allocate)),
  % first worker (client) process exits
  ?assertEqual(true, exit(Worker, kill)),
  % new client allocates Frequency and gets the same frequency
  % since it was automatically reclaimed when the first worker
  % exited
  Worker2 = spawn(ch6_frequency, worker, [[]]),
  ?assertEqual({ok, 1}, ch5_ex2:response(Worker2, allocate)).

use_link_to_monitor_client_when_allocating_a_frequency_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [fun use_link_to_monitor_client_when_allocating_a_frequency/0]}.