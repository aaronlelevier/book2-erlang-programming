%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Mar 2020 6:01 PM
%%%-------------------------------------------------------------------
-module(ch7_ex1_tests).
-author("aaron lelevier").

-include_lib("eunit/include/eunit.hrl").


birthday_test() ->
  Person = ch7_ex1:joe(),

  Ret = ch7_ex1:birthday(Person),

  ?assertEqual(person, element(1, Ret)).

joes_birthday_test() ->
  Person = ch7_ex1:joe(),

  Ret = ch7_ex1:joes_birthday(Person),

  ?assertEqual(person, element(1, Ret)).

show_person_test() ->
  Person = ch7_ex1:joe(),
  ?assertEqual(ok, ch7_ex1:show_person(Person)).