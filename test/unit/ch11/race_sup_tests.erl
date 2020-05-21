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

start_supervisor_and_add_a_child_test() ->
  {ok, Pid} = race_sup:start_link(),
  ?assertEqual(Pid, whereis(race_sup)),

  Children = supervisor:which_children(race_sup),
  ?assertEqual(1, length(Children)),

  {ok, _Pid} = race_sup:add_racer(new_racer1),
  Children2 = supervisor:which_children(race_sup),
  ?assertEqual(2, length(Children2)).


