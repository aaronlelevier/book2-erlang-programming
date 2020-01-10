%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:35 AM
%%%-------------------------------------------------------------------
-module(ch3_ex5_tests).
-author("aaron lelevier").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

filter_test() ->
  ?assertEqual([1, 2, 3], ch3_ex5:filter([1, 2, 3, 4, 5], 3)).

reverse_test() ->
  ?assertEqual([3, 2, 1], ch3_ex5:reverse([1, 2, 3])).

concatenate_test() ->
  ?assertEqual(
    [1, 2, 3, 4, five],
    ch3_ex5:concatenate([[1, 2, 3], [], [4, five]])).

%%flatten_test() ->
%%  ?assertEqual(
%%    [1, 2, 3, 4, 5, 6],
%%    ch3_ex5:concatenate([[1, [2, [3], []]], [[[4]]], [5, 6]])).