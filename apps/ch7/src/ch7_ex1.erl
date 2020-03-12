%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Mar 2020 6:00 PM
%%%-------------------------------------------------------------------
-module(ch7_ex1).
-author("aaron lelevier").
-compile(export_all).

-record(person, {name, age, phone}).

-record(name, {first, surname}).
%% can default a record field
%% can have nested record fields
-record(person2, {name = #name{}, age, phone}).

birthday(#person{age = Age} = P) ->
  P#person{age = Age + 1}.

joes_birthday(#person{age = Age, name = "Joe"} = P) ->
  P#person{age = Age + 1};
joes_birthday(P) ->
  P.

joe() ->
  #person{age = 21, name = "Joe", phone = 5678}.

show_person(#person{age = Age, name = Name, phone = Phone} ) ->
  io:format("age:~p name:~p phone:~p~n", [Age, Name, Phone]),
  ok.