%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 21. May 2020 6:37 AM
%%%-------------------------------------------------------------------
-module(racer_gs_tests).
-author("Aaron Lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").


can_update_and_get_location_test() ->
  Name = john,
  {ok, _Pid} = racer_gs:start_link(Name),

  ?assertEqual(ok, racer_gs:update_location(Name, {1, 2})),
  ?assertEqual({location, {1, 2}}, racer_gs:get_location(Name)),
  ?assertEqual({progress, 1}, racer_gs:get_progress(Name)),

  ?assertEqual(ok, racer_gs:update_location(Name, {4, 5})),
  ?assertEqual({location, {4, 5}}, racer_gs:get_location(Name)),
  ?assertEqual({progress, 2}, racer_gs:get_progress(Name)).
