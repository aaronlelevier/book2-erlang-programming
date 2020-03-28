%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 28. Mar 2020 8:18 AM
%%%-------------------------------------------------------------------
-module(ch9_ex3_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

zip_test() ->
  L1 = [1, 2],
  L2 = [3, 4, 5],

  Ret = ch9_ex3:zip(L1, L2),

  ?assertEqual([{1, 3}, {2, 4}], Ret).

zipWith_test() ->
  Add = fun(X, Y) -> X + Y end,
  L1 = [1, 2],
  L2 = [3, 4, 5],

  Ret = ch9_ex3:zipWith(Add, L1, L2),

  ?assertEqual([4, 6], Ret).
