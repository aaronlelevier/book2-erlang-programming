%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:35 AM
%%%-------------------------------------------------------------------
-module(ch3_ex1_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).

sum_test() ->
  ?assertEqual(15, ch3_ex1:sum(5)).

sum_range_test() ->
  ?assertEqual(6, ch3_ex1:sum_range(1, 3)).

sum_range_error_if_n_is_gt_m_test() ->
  ?assertException(error, function_clause, ch3_ex1:sum_range(5, 4)).