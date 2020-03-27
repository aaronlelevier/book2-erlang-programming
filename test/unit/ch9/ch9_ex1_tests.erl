%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 27. Mar 2020 7:13 AM
%%%-------------------------------------------------------------------
-module(ch9_ex1_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).

-include_lib("eunit/include/eunit.hrl").

filter_list_by_n_test() ->
  L = [1, 2, 3, 4],
  P = fun(X) -> fun(Y) -> Y < X end end,
  N = 3,

  Ret = ch9_ex1:filter_list_by_n(P(N), L),

  ?assertEqual([1, 2], Ret).

filter_map_test() ->
  L = [1, 2, 3, 4],
  P = fun(X) -> X rem 2 =:= 0 end,
  Double = fun(Y) -> Y * 2 end,

  Ret = ch9_ex1:filter_map(P, L, Double),

  ?assertEqual([4, 8], Ret).

fold_test() ->
  % NOTE: this isn't an efficient way to concatenate lists!
  Fun = fun(X, Acc) -> X ++ Acc end,
  L = [[1, 2], [5, 6]],

  Ret = ch9_ex1:fold(Fun, [], L),

  ?assertEqual([5,6,1,2], Ret).

sum_test() ->
  Fun = fun(X, Acc) -> X + Acc end,
  L = [3,4,10],

  Ret = ch9_ex1:fold(Fun, 0, L),

  ?assertEqual(17, Ret).

sum_foldl_test() ->
  Fun = fun(X, Acc) -> X + Acc end,
  ?assertEqual(10, lists:foldl(Fun, 0, [1,2,3,4])).

sum_foldr_test() ->
  Fun = fun(X, Acc) -> X + Acc end,
  ?assertEqual(10, lists:foldr(Fun, 0, [1,2,3,4])).