%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:35 AM
%%%-------------------------------------------------------------------
-module(ch3_ex2_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).

create_test() ->
  ?assertEqual([1, 2, 3], ch3_ex2:create(3)).

create_reverse_test() ->
  ?assertEqual([3, 2, 1], ch3_ex2:create_reverse(3)).
