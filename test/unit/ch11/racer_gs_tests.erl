%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 02. May 2020 8:34 AM
%%%-------------------------------------------------------------------
-module(racer_gs_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

%% pre_start -> racing -> time_exceeded
time_exceeded_if_race_duration_reached_test() ->
  Name = test1,

  % init racer
  {ok, _Pid} = racer_gs:start_link(Name),
  ?assertEqual(pre_start, racer_gs:status(Name)),

  % start race
  ?assertEqual(ok, racer_gs:start_race(Name)),
  ?assertEqual(racing, racer_gs:status(Name)),

  % wait to exceed max race duration
  timer:sleep(1000),
  ?assertEqual(time_exceeded, racer_gs:status(Name)).

%% pre_start -> racing -> finished
race_duration_end_has_no_effect_if_racer_finished_test() ->
  Name = test2,

  % init racer
  {ok, _Pid} = racer_gs:start_link(Name),
  ?assertEqual(pre_start, racer_gs:status(Name)),

  % start race
  ?assertEqual(ok, racer_gs:start_race(Name)),
  ?assertEqual(racing, racer_gs:status(Name)),

  % racer finishes race
  ?assertEqual(ok, racer_gs:finish_race(Name)),
  ?assertEqual(finished, racer_gs:status(Name)),

  % wait to exceed max race duration
  timer:sleep(1000),
  ?assertEqual(finished, racer_gs:status(Name)).
