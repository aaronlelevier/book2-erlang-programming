%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Feb 2020 6:52 AM
%%%-------------------------------------------------------------------
-module(ch6_ex3_tests).
-author("aaron lelevier").
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

can_create_child_with_mode_test() ->
  SupName = sup,
  ok = ch6_ex3:start_link(SupName, [{transient, ch6_add_one, start, []}]),

  ?assertEqual(2, ch6_add_one:request(1)),
  assert_is_pid(ch6_add_one),

  ch6_ex3:stop(SupName).

get_children_count_test() ->
  SupName = sup,
  ok = ch6_ex3:start_link(SupName, [{transient, ch6_add_one, start, []}]),

  Ret = ch6_ex3:children(SupName, count),

  ?assertEqual(1, Ret),
  ch6_ex3:stop(SupName).

child_will_be_restarted_or_not_depending_on_mode_test() ->
  SupName = sup,
  ok = ch6_ex3:start_link(
    SupName, [
      {transient, ch6_add_one, start, []},
      {permanent, ch6_add_one2, start, []}
    ]),
  SupPid = whereis(SupName),
  % pre-test
  assert_is_pid(ch6_add_one),
  assert_is_pid(ch6_add_one2),

  % kill both
  exit(whereis(ch6_add_one), kill),
  exit(whereis(ch6_add_one2), kill),

  % wait for supervisor to reply back that it has restart the
  % child processes
  receive {SupPid, children_restarted} -> void end,

  % only the permanent child process should be restarted
  ?assertEqual(1, ch6_ex3:children(SupName, count)),

  % not running assert 1 - in helper it doesn't tell us the Pid Name...
  assert_is_not_pid(ch6_add_one),
  % not running assert 2 - more verbose, but tells us the Pid Name
  ?assertEqual(undefined, whereis(ch6_add_one)),

  % permanent child pid is still running
  assert_is_pid(ch6_add_one2),

  ch6_ex3:stop(SupName).

%% helpers

assert_is_pid(Name) ->
  {status, Status} = process_info(whereis(Name), status),
  ?assert(lists:member(Status, [runnable, running, waiting])).

assert_is_not_pid(Name) ->
  ?assertEqual(undefined, whereis(Name)).
