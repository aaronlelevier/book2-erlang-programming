%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 14. Apr 2020 5:54 AM
%%%-------------------------------------------------------------------
-module(ch10_ex1_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

accumulate_test() ->
  L = [7,6,6,5,3,3,1,1],
  Ret = ch10_ex1:accumulate(L),
  ?assertEqual([{1}, {3}, {5,7}], Ret).
