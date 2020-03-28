%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 28. Mar 2020 7:27 AM
%%%-------------------------------------------------------------------
-module(ch9_ex2_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

divisible_by_test() ->
  N = 3,
  L = lists:seq(1, 10),

  Ret = ch9_ex2:divisible_by(N, L),

  ?assertEqual([3, 6, 9], Ret).

integers_squared_test() ->
  L = [1, hello, 100, boo, "boo", 9],

  Ret = ch9_ex2:integers_squared(L),

  ?assertEqual([1, 10000, 81], Ret).

intersection_test() ->
  L1 = [1, 2, 3, 4, 5],
  L2 = [4, 5, 6, 7, 8],

  Ret = ch9_ex2:intersection(L1, L2),

  ?assertEqual([4, 5], Ret).

symmetric_diff_test() ->
  L1 = [1, 2, 3, 4, 5],
  L2 = [4, 5, 6, 7, 8],

  Ret = ch9_ex2:symmetric_diff(L1, L2),

  ?assertEqual([1, 2, 3, 6, 7, 8], Ret).

