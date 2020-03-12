%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Mar 2020 5:58 AM
%%%-------------------------------------------------------------------
-module(ch7_ex2).
-author("aaron lelevier").
-compile(export_all).
-export([]).

-record(person, {name, age}).

joe() ->
  #person{age = 21, name = "Joe"}.

person(Name) ->
  #person{age = 30, name = Name}.

-spec is_joe(Person :: #person{}) -> boolean().
is_joe(Person) when Person#person.name =:= "Joe" -> true;
is_joe(_Person) -> false.
