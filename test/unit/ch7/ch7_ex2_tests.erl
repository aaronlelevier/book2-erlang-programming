%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Mar 2020 5:59 AM
%%%-------------------------------------------------------------------
-module(ch7_ex2_tests).
-author("aaron lelevier").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

is_joe_true_test() ->
  Person = ch7_ex2:joe(),
  Ret = ch7_ex2:is_joe(Person),
  ?assert(Ret).

is_joe_false_test() ->
  Person = ch7_ex2:person("Bob"),
  Ret = ch7_ex2:is_joe(Person),
  ?assertNot(Ret).

is_joe_false_for_non_record_test() ->
  Person = "Gary",
  Ret = ch7_ex2:is_joe(Person),
  ?assertNot(Ret).
