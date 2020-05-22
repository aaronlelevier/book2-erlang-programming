%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 21. May 2020 7:47 AM
%%%-------------------------------------------------------------------
-module(race_sup_tests).
-author("Aaron Lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

start_supervisor_and_add_a_child_test_() ->
  {setup,
    fun sup_setup/0,
    fun sup_cleanup/1,
    [
      fun start_supervisor_and_add_a_child/0,
      fun add_racer/0,
      fun use_dynamic_children/0
    ]}.

sup_setup() ->
  {ok, Pid} = race_sup:start_link(),
  ?assertEqual(Pid, whereis(race_sup)).

sup_cleanup(_) -> ok.

start_supervisor_and_add_a_child() ->
  Children = supervisor:which_children(race_sup),
  ?assertEqual(1, length(Children)).

add_racer() ->
  {ok, _Pid} = race_sup:add_racer(new_racer1),
  Children2 = supervisor:which_children(race_sup),
  ?assertEqual(2, length(Children2)).

use_dynamic_children() ->
  {ok, Pid} = race_sup:add_racer(new_racer2),

  Children2 = supervisor:which_children(race_sup),
  ?assertEqual(3, length(Children2)),

  % child pid is running
  ?assertEqual(true, is_list(process_info(Pid))),

  % terminate the child
  ?assertEqual(
    ok, supervisor:terminate_child(race_sup, new_racer2)
  ),

  % process is no longer running
  ?assertEqual(false, is_list(process_info(Pid))),

  % but we can restart it
  {ok, Pid2} = supervisor:restart_child(race_sup, new_racer2),
  ?assertEqual(true, is_list(process_info(Pid2))),

  % can't delete it because it's running
  ?assertEqual(
    {error, running},
    supervisor:delete_child(race_sup, new_racer2)
  ),

  % ok terminate and delete it
  ?assertEqual(3, length(supervisor:which_children(race_sup))),
  ?assertEqual(
    ok, supervisor:terminate_child(race_sup, new_racer2)
  ),
  ?assertEqual(
    ok, supervisor:delete_child(race_sup, new_racer2)
  ),
  ?assertEqual(2, length(supervisor:which_children(race_sup))).
