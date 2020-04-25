%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 24. Apr 2020 7:23 AM
%%%-------------------------------------------------------------------
-module(race_fsm_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

number_of_racers_is_tracked_test() ->
  {ok, _Pid} = race_fsm:start_link(2),
  ?assertEqual(#{max_racers => 2,num_racers => 0}, race_fsm:get_racer_count()),

  ?assertEqual({ok, racer_added}, race_fsm:add_racer(steve)),
  ?assertEqual(#{max_racers => 2,num_racers => 1}, race_fsm:get_racer_count()),

  ?assertEqual({ok, racer_added}, race_fsm:add_racer(joe)),
  ?assertEqual(#{max_racers => 2,num_racers => 2}, race_fsm:get_racer_count()),

  ?assertEqual({error, race_full}, race_fsm:add_racer(sam)).