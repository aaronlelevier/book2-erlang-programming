%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 4:35 PM
%%%-------------------------------------------------------------------
-module(max_m_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").
-compile({parse_transform, do}).

max_is_not_triggered_test() ->
  ?assertEqual(8, do([max_m || 4,5,8])).

max_is_triggered_and_first_value_gt_10_returned_test() ->
  ?assertEqual(20, do([max_m || 4, 20, 30])).