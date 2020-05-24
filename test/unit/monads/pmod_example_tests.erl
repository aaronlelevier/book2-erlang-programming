%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 4:54 PM
%%%-------------------------------------------------------------------
-module(pmod_example_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").
-compile({parse_transform, pmod_pt}).

b_test() ->
  ?assertEqual(
    11,
    (pmod_example:new(10)):b()
  ).